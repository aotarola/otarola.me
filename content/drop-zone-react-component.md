---
{
  "author": "Andres Otarola",
  "title": "Simple Drop Zone React Component",
  "description": "Simple way to drag and drop files as a React component",
  "image": "v1627861555/elm-pages/article-covers/photo-1471107340929-a87cd0f5b5f3_mczjfg.jpg",
  "published": "2022-02-27",
}
---

A few days ago I set up a small app in React that included file uploading functionality, nothing too 
fancy, except that I wanted to add drag and drop functionality to it.

The key objectives of this article are:
* How to interact with dragged files over a drop zone
* Create **React** component with drop functionality

**_NOTE_:** As you probably noticed, the focus here is the **_drop zone_** part rather than creating a draggable object, this
is because we're going to leverage the Host OS's file dialog system for it (i.e. the dragged files will be our dragged object).

At the end the final component will look like:

```js
import React, { useEffect } from 'react';

export default function FileUploaderDND(props) {
  const state = {
    inDropZone: false,
    fileList: [],
  };

  const reducer = (state, action) => {
    switch (action.type) {
      case 'AddToDropZone':
        return { ...state, inDropZone: action.inDropZone };
      case 'AddToList':
        return { ...state, fileList: [...state.fileList, ...action.files] };
      case 'ResetList':
        return { ...state, fileList: [] };
      default:
        return state;
    }
  };

  const [data, dispatch] = React.useReducer(reducer, state);

  const handleDragEnter = event => {
    event.preventDefault();
    dispatch({ type: 'AddToDropZone', inDropZone: true });
  };

  const handleDragLeave = event => {
    event.preventDefault();
    dispatch({ type: 'AddToDropZone', inDropZone: false });
  };

  const handleDragOver = event => {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
    dispatch({ type: 'AddToDropZone', inDropZone: true });
  };

  const handleDrop = event => {
    event.preventDefault();

    let files = [...event.dataTransfer.files];

    if (files) {
      dispatch({ type: 'AddToList', files });
      dispatch({ type: 'AddToDropZone', inDropZone: false });
    }
  };

  useEffect(() => {
    if (data.fileList.length > 0) {
      props.changeInputFile(data.fileList);
      dispatch({ type: 'ResetList' });
    }
  }, [data.fileList, data.fileList.length, props]);

  return (
    <div
      onDrop={event => handleDrop(event)}
      onDragOver={event => handleDragOver(event)}
      onDragEnter={event => handleDragEnter(event)}
      onDragLeave={event => handleDragLeave(event)}
    >
      <div className={data.inDropZone ? 'about-to-drop' : ''}>
        {props.children}
      </div>
    </div>
  );
}
```

## Understanding the Drag'n drop concepts

The [MDN][mdn]'s Drag and Drop API documentation is pretty good at explaining the concepts, in this article
I'm going to focus on the events relevant to the drop zone:

[mdn]: https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API

* `ondragenter`: a draggable object enters into the drop zone
* `ondragover`: a draggable object is being dragged over the drop zone
* `ondragleave`: a draggable object exits the drop zone
* `ondrop`: a draggable object has been dropped into the drop zone

## Strategy


### 1. Define the model

Ok, the events are pretty straightforward, now, we'll need a state that will represent these
actions in a given time, a good starting point could be a simple Boolean value that tracks the presence of
a draggable object in a drop zone. But in our case, we want to model it for a file dialog, so we also need
to have a list that keeps track of the dragged files:

```js
const state = {
  inDropZone: false,
  fileList: [],
}

```

### 2. Implement the levers for the new model

The state cannot be changed directly, that'll be a mutation and we're in a pure function, so that is a hard
_**nono**_, instead, we'll be creating new models with the updated value.

Currently our model can have several states:

* `{inDropZone: true, fileList: []}`
* `{inDropZone: false, fileList: []}`
* `{inDropZone: true, fileList: [File]}`
* `{inDropZone: false, fileList: [File]}`

To simplify the generation of such possibilities it is better to use the `useReducer` hook, which let us
implement a function that its sole purpose is to generate a new model (A.K.A the *reducer* function):

```js
const reducer = (state, action) => {
  switch (action.type) {
    case 'AddToDropZone':
      return { ...state, inDropZone: action.inDropZone };
    case 'AddToList':
      return { ...state, fileList: [...state.fileList, ...action.files] };
    case 'ResetList':
      return { ...state, fileList: [] };
    default:
      return state;
  }
};

const [data, dispatch] = React.useReducer(reducer, state);

```

Here, `data` will be the new state that its going to be used for **read** operations, and whenever we need
to generate a new `data` model, we can invoke the `dispatch` function.

### 3. Implement the handlers

Next, we will need a way to invoke the possible state change with specialized functions for each :

```js
const handleDragEnter = event => {
  event.preventDefault();
  dispatch({ type: 'AddToDropZone', inDropZone: true });
};

const handleDragLeave = event => {
  event.preventDefault();
  dispatch({ type: 'AddToDropZone', inDropZone: false });
};

const handleDragOver = event => {
  event.preventDefault();
  event.dataTransfer.dropEffect = 'move';
  dispatch({ type: 'AddToDropZone', inDropZone: true });
};

const handleDrop = event => {
  event.preventDefault();

  let files = [...event.dataTransfer.files];

  if (files) {
    dispatch({ type: 'AddToList', files });
    dispatch({ type: 'AddToDropZone', inDropZone: false });
  }
};
```

Notice the usage of `event.dataTransfer` object in `handleOver` and `handleDrop` functions, that object
is automatically provided to us in order to access what's being dragged.




### 4. Bind all into the drop element

One of the last things left is to actually bind all the specialized functions into the 
element that will act as the drop zone:

```js
<div
  onDrop={event => handleDrop(event)}
  onDragOver={event => handleDragOver(event)}
  onDragEnter={event => handleDragEnter(event)}
  onDragLeave={event => handleDragLeave(event)}
>
  <div className={data.inDropZone ? 'about-to-drop' : ''}>
    {props.children}
  </div>
</div>
```

__NOTE__: I'm conditionally adding the `about-to-drop` class name, to trigger a `.5` opacity effect when dragging over it.

### 5. Listen for side-effects
And finally we need to account the fact that a drag action is actually a side-effects, in other words, is
making changes into the world and we need to listen for them:


```js
  useEffect(() => {
    if (data.fileList.length > 0) {
      props.changeInputFile(data.fileList);
      dispatch({ type: 'ResetList' });
    }
  }, [data.fileList.length]);

```

Here the actual change is the size of the file list, because whenever we drop it we're transferring the 
files from the API into the state that we're keeping track of, then we trigger the outer function that will actually do something interesting with those files, and finally, we clean up the list, the function will be triggered once again, but the `if` guard will prevent any further execution 🤓.
