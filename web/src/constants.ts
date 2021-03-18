import ENV from 'react-dotenv'

export enum Urls {
  SIGN_IN = '/signin',
  SIGN_UP = '/signup',
  CREATE_TRANSMISSION = '/transmissions/new',
  EDIT_TRANSMISSION = '/transmissions/:uuid'
}

export enum TransmissionTypes {
  LIVE = 'live',
  UPLOAD = 'upload'
}

export const env = ENV as unknown as Env | undefined