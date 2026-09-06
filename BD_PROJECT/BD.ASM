screen holds 24x18 cells while gameboard consists of 40x30 cells

screenX=1
if x>16 and x<25 then screenX=9
if x>24 then screenX=17
screenY=1
if y>12 and y<19 then screenY=7
if y>18 then screenY=13


OLD SOURCE FRAGMENTS:

#!/usr/bin/wish

# 20200101 start the project
# 20200107 Rockford is moving around
# 20200108 global array and stop mem. leaks
# 20200111 flies (the last day of [the Mapasoft] cassette recorder... fuck!)
# 20200113 empty dict. fix for x and y flies, neat level files for BD6 (CHAOS)
# 20200114 x-y-flies and diamonds are alive! (internal movements) and peeks (control+arrow (without pushing stone yet))
# 20200115 stones can be 'peeked', plasma is alive and flies die when in contact with plasma
# 20200116 free fall made properly (falling o/* eliminates x/y/R) and magic walls work correctly
# 20200117 no 'pause game' in this version
           -- actually this feature will not be present
           -- no 'lives' either - free play mode
# TODO home blinking when diamonds are collected/blast/noise
# TODO display score, choose and load level
# TODO restore BD1

...

    # tt = total time for a single game (read from level metadata)

    # if plasma is confined at the beginning it does not turn into diamonds - it waits/pulses
    # freeing plasma from confinement causes its growth
    # when plasma reaches critical mass (counted in plasma-cells) it turns into stones
    # unless it is confined again - then it turns into diamonds
    # flies (both) can destroy plasma completely or make it turning into diamonds
    # plasma can be stopped by Rockford, stones, (magic) walls, iron, and fly's explosion
    # plasme grows over grass or void
    # pl_mass: plasma mass (number of occupied cells) - set when level is loaded
    variable pl_mass 0
    # pl_cmass: plasma critical mass - when it turns to stones - read from level metadata
    variable pl_cmass 100

    # if plasma is trapped (cannot grow) at the beginning (pl_trap=1 by default)
    # if plasma can grow, then it is set to pl_trap=0
    # if plasma can grow and pl_mass &gt;= pl_cmass, it turns into stones ('stonification')
    # if plasma cannot grow and pl_mass &lt; pl_cmass (confinement), it turns into diamonds
    variable pl_trap 1

    variable bx 40 # map size (in cells) 34x20
    variable by 22

    variable diamval 10
    variable score 0
    variable diam2collect 10

    # a) at the beginning magic wall is usually inactive (magic_stat=0) and o/* activates it (magic_stat=1) when falling through
    # once activated, it lasts in state magic_stat=1 (start glittering) until magic_t ticks down to zero (read from level metadata)
    # if magic_t=0 =&gt; magic_exp=1 and from now on it only annihilates o/* (stop glittering)
    # b) level can also start with magic walls activated (glittering, magic_stat=1)
    variable magic_stat 0
    variable magic_exp 0
    variable magic_t 100

    # artifacts:
    variable BD_VOID " "
    variable BD_STONE "o"
    variable BD_GRASS "."
    variable BD_IRON "#"
    variable BD_WALL "="
    variable BD_DIAMOND "*"
    variable BD_PLASMA "@"
    variable BD_YFLY "y"
    variable BD_XFLY "x"
    variable BD_MAGIC_INACTIVE "-"
    variable BD_MAGIC_ACTIVE "+"
    variable BD_HOME_INACTIVE "F"
    variable BD_HOME_ACTIVE "a"
    
    or: d(0) [i]ron
        d(0) [w]all
        d(0) [s]tone
        d(0) [g]rass
        d(8) [d]iamond
        d(.) [R]ockford
        d(8) [x]-fly
        d(8) [y]-fly
        d(3) [v]oid (noise, blast)
        d(2) [h]ome (active, inactive)
        d(8) [p]lasma
        d(8) [m]agic-wall
    
        d(n) = dynamic object with n phases
        d(0) = static object (0 dynamic phases)

    
    # home0   - inactive
    # home1   - active (rotate 1 or 2)
    variable BD_NOISE "z"
    # blast takes place when diamonds are collected
    variable BD_BLAST "!"

    variable BD_ROCKFORD "H"

    # phases of objects that changes its visual state: flies, plasma, diamond, magic wall and actually void/noise
    variable yphase 0
    variable xphase 0
    variable pphase 0
    variable dphase 0
    variable mphase 0
    variable vphase 0
    # Rockford also should have his customized 'phase' when moving or peeking
    variable rphase 0

    #   stone is pushed with a given probability
    #   Rsv =&gt; vRs and vsR =&gt; sRv; ONLY left and right pushing stone allowed (no lifting or pushing down)

    # free fall (gravity) for stone and diamond
    # falling stone or diamong may hit a fly on their way
    # by default objects don't fall # this prevents the case, when R. drops o/*, it lands on a grass, and then R. goes underneath to be killed...
    # stone slides (when falling) over stone, diamond, or wall (no magic wall!) (direction is important, different combinations for o/o o/* o/w */o */* */w)
    # stone or diamond does not slide over plasma, grass, iron and home (active/inactive)
    # if magic wall is expired it just annihilates falling stones and diamonds

    # explosion might annihilate a stone, diamond, plasma, (magic)wall, both flies, home, grass and even Rockford, but not iron!
    # exploding x-fly produces diamonds that should be introduced for free fall
    # gravity for diamonds == gravity for stones

    # pushing or peeking a stone can change its stats (should be 0 = not falling!, it is important in the context of magic walls)
    # magic wall: delete diamond from a table and create a stone (or the other way) (only when active), otherwise: annihilate both falling objects

    # killing fly needs update in a global table
    # killing x-fly needs update ... and introduce new diamonds that can possibly be experienced by gravity

    #   free fall of stones and diamonds and plasma growth
    #   we start from the bottom as gravity exerts on the nearest objects first
    #   falling stone/diamond should have a status of its kinematics (not kinetics!)
    #   if s/d falls on Rockford ==&gt; game over
    #   if s/d falls on x/y-fly ==&gt; diamonds or void
    #   if s/d falls on magic wall ==&gt; (depending on m-wall state) transforms to d/s or just annihilates it

    # Plasma Can Grow
    set PCG 0
    # plasma index
    set k 0
    # plasma possible directions
    array set PL {}

    # exclude bottom-line from falling IF NECESSARY! or just make artificial iron-border (this would eliminate most of boundary problems)
    # some cells might have already been occupied by falling objects -&gt; extra check if particular index in 'TF' exists
    # check random direction (up, left, down or right) and expand plasma over void or grass with respect to probability
    # probability increases as pl_mass tends to pl_cmass
    # if board is not surrounded by iron ring, make sure plasma does not grow out of bounds!
    # Rockford cannot be 'faster' than plasma's expansion and cannot erase it! - causality issue :)
    # plasma CANNOT annihilate Rockford!

    # peeking-home is possible when home is activated

    #                                           *                    *      *
    # picking diamonds should not be too fast: H* --&gt; H*  should be H* --&gt; H  --&gt; H*
    # when Rockford consumes a diamond increase the score and decrease global population of diamods on the board

    # fly's explosion should be animated
    # when exploded: x-fly produces 3x3 diamonds while y-fly produces 3x3 void
    # if explosion catches another fly, it must be removed too! (no additional explosion, just annihilation)
    # if explosion catches Rockford, game is over --&gt; separate procedure to decorate the last moment with 9 diamonds :)

    # in the original BD Rockford can run upward on the right side of any confined (in the grass) fly avoiding sudden contact (a bug or a feature?)
    # -- this depends on the fly's status!


    # level metadata
    #
    #	1 time [seconds] 000 -- 999
    #	2 diamonds to collect
    #	3 diamonds value before time limit
    #	4 diamonds value after time limit > before
    #	5 colour palette (0-255)
    #	6 plasma critical mass [cells]
    #	7 level id
    #	8 exp. time for magic wall [seconds]

