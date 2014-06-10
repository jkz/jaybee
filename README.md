# Jaybee
## What is it?
Jaybee is a jukebox.

The aim of Jaybee is to provide a platform where a community of people can contribute to a public and audibly synchornised playlist.

Listeners can tune into the playlist through either their headphones or via a public audio player within their location: office, home, school.

Jaybee aims to provide listeners with the controls to easily manage public playlists fairly.

[More detail about the idea behind Jaybee](http://www.peteroome.com/2013/12/19/the-office-jukebox-mvp-i-dream-of.html).

## Getting started

**Install Meteor**:  
`$ curl https://install.meteor.com/ | sh`

**Clone this repository**  
`$ git clone git@github.com:coolbox/jaybee.git`

**cd into the project folder**  
`$ cd jaybee`

**Start meteor**  
`$ meteor`

**Visit your web browser**  
[http://localhost:3000](http://localhost:3000)

## The Problems Jaybee Solves
### Well, aims to solve…
From my experience of using public jukeboxes, i've noticed a few problems that regularly arise:

1. Tracks are skipped - especially frustrating if you're the person who has taken the time to select them.
2. Nobody (or only a couple of users) contibute: often results in silence.
3. The music is too loud - some people struggle to concentrate with music that is too loud.
4. The music isn't loud enough - others like their music to be quite loud.

### Current features
1. Soundcloud login.
2. Soundcloud music streaming.
3. Search Soundcloud for music.
4. Add Soundcloud tracks to a public playlist.
5. See who has added each track to the playlist.
6. Only the person who has added a track to the playlist, can remove it.
7. Users can "favourite" a track directly to their own Soundcloud account.
8. Link directly to a track on Soundcloud
9. See a list of listeners who are tuned in.
10. Played tracks are added to a play history.
11. Up and down voting on tracks to gauge public opinion.

### Coming soon features
1. A track can only be skipped if 50% of the listening audience also presses 'skip'.
2. Anti-silence: if the playlist is empty, Jaybee will select music from the play history to fill the silence with.
3. Non-Soundcloud sign-up and sign-in.
4. A pause button that resumes the track based on where the playlist is currently at.
5. Volume controls for a 'master' player; for example a soundsystem in an office.
6. Multiple rooms - at present there is only a single room. This is obviously a problem when it comes to hosting the project online.

### Nice-to-have, MVP omissions
1. Estimates of what time a track can be expected to be played.
2. Share a track, via Facebook or Twitter.
3. Last.fm scrobbling to listeners accounts based on who added the track to the playlist.
4. Add tracks to your own personal Soundcloud playlists.
5. Auto-generate a playlist on Soundcloud everyday based on what's been played the day before.
6. Keyboard shortcuts.
7. New Day Clean Slate - each morning wipes leftover tracks from the day before.
8. Play History - show users what has previously been played.

## Music
Music is currently sourced from Soundcloud only.

I'd like to add the ability to source music from multiple services. Platforms to consider:

- Spotify
- Rdio
- YouTube
- Hype Machine
- Shuffler.fm

## Technology
Jaybee has been built using [Meteor](https://www.meteor.com/).

Meteor is a Javascript framework that allows you to build 'top-quality web apps in a fraction of the time'.

## Contributions
Contributors and contributions are very welcome.

Please feel free to submit issues, pull requests and suggestions of what this platform should do.

If you're not familiar with git or Github and would still like to contribute then i'd be more than willing to help. Just reach out and ask…

You can reach me on Twitter: [@zoltarSpeaks](https://twitter.com/zoltarspeaks)

### Improvements & Bug Fixes
Proposed improvements to, or repairs for problems in, the project are welcome. (While suggestions and opinions will be accepted, it’s always better if you can actually provide the change you’re proposing.)

### Design & UI
I welcome proposals for a project interface and logo.

If you would like to be involved in the design side of this project then please don't hesitate to reach out and speak to me: [pete@betahive.com](mailto:pete@betahive.com)

Logo art would be featured on the platform interface itself.

Credits for all design contributions would appear, atleast, within the source code of the project as well as on this project page.