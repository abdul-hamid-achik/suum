import ENV from 'react-dotenv'

export enum Urls {
  SIGN_IN = '/signin',
  SIGN_UP = '/signup',
  CREATE_TRANSMISSION = '/new',
  EDIT_TRANSMISSION = '/t/:uuid',
  VIEW_TRANSMISSION = '/:slug'
}

export enum TransmissionTypes {
  LIVE = 'live',
  VOD = 'vod'
}

export enum Environment {
  DEV = "DEV",
  PRODUCTION = "PRODUCTION"
}

export const env = ENV as unknown as Env | undefined