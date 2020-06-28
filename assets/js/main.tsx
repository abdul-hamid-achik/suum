import React, {useState, useEffect} from 'react'
import {
    Hero,
    Tabs,
    TabList,
    Tab,
    TabLink,
    HeroHeader,
    HeroBody,
    HeroFooter,
    NavbarBrand,
    NavbarBurger,
    NavbarItem,
    Navbar,
    NavbarEnd,
    Icon,
    NavbarStart,
    NavbarMenu,
    Container,
} from 'bloomer'
import {useRoutes, Link} from 'raviger'
import routes from './router'

const Main = () => {
    const [isBurgerActive, setBurgerActive] = useState(false)
    const [isPlayingVideo, setPlayingVideo] = useState(false)
    const [isPlayingAudio, setPlayingAudio] = useState(false)

    const route = useRoutes(routes)
    const onClickNav = () => setBurgerActive(!isBurgerActive)

    useEffect(() => {
        console.log(isPlayingAudio, isPlayingVideo)
    }, [isPlayingAudio, isPlayingVideo])
    return <Hero isColor='primary' isFullHeight={true}>
        <HeroHeader>
            <Navbar>
                <NavbarBrand>
                    <NavbarItem>
                        Suum
                    </NavbarItem>
                    <NavbarBurger isActive={isBurgerActive} onClick={onClickNav}/>
                </NavbarBrand>
                <NavbarMenu isActive={isBurgerActive} onClick={onClickNav}>
                    <NavbarStart>
                        <Link className="navbar-item" href='/'>Home</Link>
                        <Link className="navbar-item" href='/new'>Schedule</Link>
                    </NavbarStart>
                    <NavbarEnd>
                        <Link className="navbar-item" href='/join'>
                            Join
                        </Link>
                        <Link className="navbar-item" href='/enter'>
                            Enter
                        </Link>
                        <Link className="navbar-item" href='/leave'>
                            Leave
                        </Link>
                    </NavbarEnd>
                </NavbarMenu>
            </Navbar>
        </HeroHeader>

        <HeroBody>
            <Container hasTextAlign='centered'>
                {route}
            </Container>
        </HeroBody>

        <HeroFooter>
            <Tabs isBoxed isFullWidth>
                <Container>
                    <TabList>
                        <Tab>
                            <TabLink onClick={(event) => {
                                dispatch(settingsSlice.actions.playVideo())
                                setPlayingVideo(!isPlayingVideo)
                            }}>
                                {isPlayingVideo ? <Icon className='fas fa-video'/> :
                                    <Icon className='fas fa-video-slash'/>}
                            </TabLink>
                        </Tab>
                        <Tab>
                            <TabLink onClick={() => setPlayingAudio(!isPlayingAudio)}>
                                {isPlayingAudio ? <Icon className='fas fa-microphone'/> :
                                    <Icon className='fas fa-microphone-slash'/>}
                            </TabLink>
                        </Tab>
                        <Tab>
                            <TabLink>
                                <Icon className="fas fa-cog"/>
                            </TabLink>
                        </Tab>
                    </TabList>
                </Container>
            </Tabs>
        </HeroFooter>
    </Hero>
}

export default Main