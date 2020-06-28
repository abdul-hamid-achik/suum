import { configureStore, createSlice } from '@reduxjs/toolkit'

const settingsSlice = createSlice({
    name: 'settings',
    initialState: {
        playingVideo: false,
        playingAudio: false,
        camera: null,
        microphone: null,
    },
    reducers: {
        playVideo(state, action) {
           state.playingVideo = true
        },
        stopVideo(state, action) {
            state.playingVideo = false

        }
    }
})

const store = configureStore({
    reducer: settingsSlice.reducer
})

export type AppDispatch = typeof store.dispatch

export default store
