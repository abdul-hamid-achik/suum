type UUID = string
interface Transmission {
    uuid: UUID
    name: string
    thumbnails?: Thumbnail[]
    preview: string
    sprite: string

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
}

type AuthToken = string