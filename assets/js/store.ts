import { configureStore, createSlice } from '@reduxjs/toolkit'

const settingsSlice = createSlice({
    name: 'settings',
    initialState: {
        playingVideo: true,
        playingAudio: true,
        camera: null,
        microphone: null,
    },
    reducers: {
        playVideo(state, action) {
           state.playingVideo = true
        },
        stopVideo(state, action) {
            state.playingVideo = false
        },
        playAudio(state, action) {
            state.playingAudio = true
        },
        stopAudio(state, action) {
            state.playingAudio = false
        }
    }
})

const store = configureStore({
    reducer: settingsSlice.reducer
})
export const {playVideo, stopVideo, playAudio, stopAudio} = settingsSlice.actions
export default store
