## Heatwave

Portfolio project of [Elixir][elixir] and [Phoenix LiveView][liveview].

[elixir]:   https://elixir-lang.org/
[liveview]: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html


## Motivation

We have minisplit HVAC, and have had something of a nightmare scenario: leaking
twenty seven pounds of refrigerant over time; a grinding compressor that would
soon fail; its replacement louder than the originally promised "quiet" model;
the inability to run any room on the low fan setting; intermittent, daily
system shutdowns (with a generic error) without any cause; and without any
diagnosis no matter how many times we call the installer (or a second opinion)
or have the manufacturer hook into the system over screenshare.

Have you tried turning it off and back on again? Only thing keeping us cool.

Once the walls went up, installing central air was no longer an alternative.
Minisplits are still the right answer, anyway, to set temperatures per room.
**Instrument the HVAC system.** Data logging from HVAC had no anomalies, and
systematically stepping through the installation components did not reveal
_additional_ errors.

1. Clip temperature sensors onto each HVAC branch refrigerant coil.
2. Stream telemetry from microcontrollers into a central database.
3. Corroborate system shutdowns with ground-truth data of each subsystem.


## Habit 7: Sharpen the Saw

**2008.** I reviewed mnesia to better understand the architecture of a project
where I was lead on creating a low-cost SMS gateway out of an ordinary Android
phone. I also wanted to better understand emerging NoSQL technologies.

**2011.** I had selected XMPP to prototype projects exploring social, local,
mobile capabilities of an in-house platform. This involved deploying OTP and
writing ejabberd modules. It would later be replaced by redis.

**2018.** I wanted a general-purpose language in my "personal SDK" that wasn't
blub. I included Elixir as part of the evaluation, and would ultimately choose
OCaml. In particular, I need to ship binaries as a systems programmer.

(I would later choose V, in which blub is secondary to the design principle of
zero dependencies. A project needs only POSIX and a C compiler, vendoring
everything including the language runtime. It is otherwise remarkably difficult
to escape the vast incidental complexity introduced by the toolchain.)

**2020-2022.** I needed a UI toolkit for rapid application development in a
clinical setting for iterative (IRB approved) workflows in managing
drug-resistant chronic disease.

<details>
<summary>My notes on Elixir Desktop and Scenic from 2022.</summary>

(Ed. note: Unedited _notes to self_ from a highly critical evaluation of UI
 toolkits viewed from a **top-down** software design process. When looking
 across many technologies, it's quite likely that you miss something, either
 because it wasn't well documented at the time or you were moving too quickly.
 There's no doubt that the projects in question have their own merit.)

Elixir Desktop is a container for Phoenix LiveView.
Scenic is GL-based (and only Linux and macOS).

I was interested in Elixir Desktop because I have a use case that's
appropriate to LiveView: integrate telemetry from multiple sensors, in
a specific environmental/individual context (i.e. a given patient in a
specific room setting), synchronize to wall-clock time, radiate
information to one or many heterogeneous dashboard views. What is
more, one-off prototyping would be more common than a deployed web
form—enable a physician to try different questions without updating
native apps. Any production use is still beyond the horizon, so my
exercise is primarily in making sure I have the right tools and
runtimes available to me for when the time comes.

I know that nothing really comes "for free" but if someone's sorted
out the build workflow across big3 wx and mobile, I would leverage
this if I could. It's not obvious from the project description or the
2021 conference video, but Elixir Desktop is apparently first and
foremost about self-contained applications that runs locally. Meaning,
it talks to a web server on localhost.

Now, this is great for sport, but what's the point except for adding a
distribution channel for a single-user web application. At which
point, the use of OTP is risible.

So, obviously I don't want Elixir Desktop. Some of the ideas might
still be relevant, if I really do think that LiveView simplifies my
programming model, and it might. But let's be honest, Lisp macros on
the server and native clients are not all that verbose, especially if
you can sort out some interface definition language.

Meanwhile, Scenic is really about creating UIs for the Nerves project.
If your use case is to package "firmware" in the form of OTP with just
enough OS (which impressively is marketed at 30MB), and to have a UI
for IoT, then this has merit.

</details>

I would later choose Flutter.

**2025.** Stay sharp on technologies for high-volume in-house telemetry.
