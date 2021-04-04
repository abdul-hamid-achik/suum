type UUID = string

interface Transmission {
    uuid: UUID
    slug: string
    name: string
    thumbnails?: Thumbnail[]
    preview: string
    sprite: string
    type: string
    user: User
    preview_url?: string
    sprite_url?: string
}

interface Thumbnail {
    uuid: UUID
    url: string
    from: string
    to: string
    timestamp: string
}

interface User {
    uuid: UUID
    email: string
    password?: string
}

type AuthToken = string

interface Env {
    HTTP_API_HOST: string
    WS_API_HOST: string
    RTMP_HOST: string
    ENVIRONMENT: "DEV" | "PRODUCTION"
}