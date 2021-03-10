type UUID = string
interface Transmission {
    uuid: UUID
    name: string
    thumbnails?: Thumbnail[]
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