(define (problem belkan-test1)

    (:domain belkan1-domain)

    (:objects
        z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14
        z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - room
        actor knight witch princess teacher - NPC
        oscar gold apple rose book - object
        n e w s - orientation
        belkan - player
    )

    (:init
        ;-----------------------------------------------------
        ; Paths from zone 1 to zone 25
        ;-----------------------------------------------------

        (path z1 z2 e)

        (path z2 z1 w)
        (path z2 z7 s)

        (path z3 z4 e)
        (path z3 z8 s)

        (path z4 z3 w)
        (path z4 z9 s)

        (path z5 z10 s)

        (path z6 z7 e)
        (path z6 z11 s)

        (path z7 z2 n)
        (path z7 z6 w)
        (path z7 z8 e)

        (path z8 z3 n)
        (path z8 z7 w)
        (path z8 z13 s)

        (path z9 z4 n)
        (path z9 z10 e)

        (path z10 z5 n)
        (path z10 z9 w)
        (path z10 z15 s)

        (path z11 z6 n)
        (path z11 z12 e)
        (path z11 z16 s)

        (path z12 z11 w)
        (path z12 z13 e)
        (path z12 z17 s)

        (path z13 z8 n)
        (path z13 z12 w)
        (path z13 z14 e)
        (path z13 z18 s)

        (path z14 z13 w)
        (path z14 z15 e)
        (path z14 z19 s)

        (path z15 z10 n)
        (path z15 z14 w)

        (path z16 z11 n)

        (path z17 z12 n)
        (path z17 z22 s)

        (path z18 z13 n)

        (path z19 z14 n)
        (path z19 z24 s)

        (path z20 z25 s)

        (path z21 z22 e)

        (path z22 z17 n)
        (path z22 z21 w)

        (path z23 z24 e)

        (path z24 z19 n)
        (path z24 z23 w)
        (path z24 z25 e)

        (path z25 z20 n)
        (path z25 z24 w)

        ;-----------------------------------------------------
        ; Rooms where the NPCs are located
        ;-----------------------------------------------------

        (at z3 witch)
    	(at z9 princess)
    	(at z11 actor)
        (at z20 teacher)
    	(at z21 knight)


        ;-----------------------------------------------------
        ; Rooms where the objects are located and 'on-floor' status
        ;-----------------------------------------------------

        (at z7 apple) (on-floor apple)
    	(at z10 rose) (on-floor rose)
    	(at z14 oscar) (on-floor oscar)
    	(at z12 book) (on-floor book)
    	(at z2 gold) (on-floor gold)

        ;-----------------------------------------------------
        ; Player status
        ;-----------------------------------------------------

        (at z13 belkan)
        (compass n)
    )

    (:goal
        (AND
            (has-object witch)
            (has-object teacher)
            (has-object knight)
            (has-object actor)
            (has-object princess)
         )
    )
)
