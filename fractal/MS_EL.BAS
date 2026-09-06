' EQUIPOTENTIAL LINES OF THE MANDELBROT SET
'
' Taken from the book of fractals
' by H.-O. Peitgen, H. Juergens, D. Saupe (1996)
'
' 2020-06-06 (p.534)
' ---------------------------------------------------------------------------
' Algorithm draws consecutive approximations of M - the Mandelbrot set.
' Namely, it goes along equipotential lines given by p_M(c) = 2^k
' which surround M and determine its boundary.
' Such method is much faster than calculating a matrix of pixels
' to check wheter a given point belongs to M (modulo iteration).
'
' The algorithm is based on triangulation of the complex plane.
' Given a triangle spanned by z1, z2 and z3, we calculate
' three adjacent triangles by means of symmetric reflection of a vertex
' along a center of an opposite side. For example, if we want to
' transform z1, then z1new = z2+z3-z1 and z1new, z2 and z3 become
' vertices of a new adjacent triangle. Using this procedure
' we can obtain any triangle on the plane.
'
' The goal is to go through entire boundary of M_k stepping on a sequance
' of triangles that approximate M_k.
' We call a "fully marked" triangle the one that has at least one vertex
' inside M_k (label 1) and the other (vertex) outside M_k (label 0). Such
' triangle must crosses the boundary of M_k. The algorithm produces
' a sequence of fully marked triangles that cover the boundary of M_k.
' A side of a triangle is called "transversal", if one end belongs to M_k
' and the other one lies outside M_k. Hence a triangle is fully marked if
' at least one side is transversal. In other words, any triangle either
' has no transversal sides or it has exactly two transversal sides.
' There are only 4 ways to assign a label to vertices of a triangle.
' Triangle has 0, 1, 2 or all vertices inside M_k, then the numbers of
' transversal sides read 0, 2, 2 and 0, respectively. It implies, that
' exactly two triangles adjacent (having common side) to a fully marked
' triangle must be fully marked too. Moreover, every fully marked triangle
' sits in a chain of fully marked triangles. Using this, it is easy to
' prepare such a chain. Suppose we start with a fully marked triangle.
' We choose one (of two) transversal side and we repeat two steps:
' STEP 1: Reflect opposite vertex along the center of the side. Reflected
'         point and the side (of reflection) consitute a new fully marked
'         triangle that intersects with M_k.
' STEP 2: A new triangle intersects the boundary of M_k. It has two
'         transversal sides: the one used to reflect in the previous step
'         and the next one. Second side becomes a new reflecting side.
' We repeat the steps until we go back to the fully marked triangle
' we started off.
' This algorithm can be generalized to higher dimensions.
'
' Label 500 - details:
' (sub-)Routine checks if c (rec = Re(c), imc = Im(c))
' lies inside or outside of the set M_k; the condition is
' determined by the disk: D^2 = {z : |z| < 16}.
' For k=2, one gets a circle of radius 16 - the boundary od D^2. For
' less values of k one gets better approximations of M.
'
' We provide a starting level, a final level and increment, eg: 0, -15, -5.
' We start in c=0 (in M) and then we go along a real positive semiaxis
' using small steps until we reach a point c outside M_k.
' In such point we place the first transversal side of a fully marked
' triangle. Arrays x and y hold coordinates of vertices of the triangle.
' We assume vo=1, vo=2 and vn=3 and define x(vi)=i-1
' and y(vi)=0 which corresponds to vertices of a triangle that lies
' inside M_k (internal point). Then, x(vo)=i and y(vo)=0
' correspond to a vertex that lies outside M_k (external point).
' We, too, assume that x(vn)=i and y(vn)=1 (new point).
' We draw internal point and we store coordinates of all points for further
' processing (comparison). Then we go along the boundary.
' First we examine a new point. If it is inside, then we draw a line
' from this point and reassign the flags:
' new point --> vo and previous point --> vt. Next, the point is reflected
' along the center of opposite side of a triangle
' that is established by a new internal point and external point. Easy... :)
' Reflected point becomes a new point. Otherwise, if a new point is outside,
' then it is not plotted and it becomes vo while previous external point
' becomes vt and is undergoes reflection. We repeat the procedure until we
' reach the starting point.

SCREEN 12

DIM x(3), y(3)
x0 = 320
y0 = 240
s = .01
ki = 0     ' initial
kf = -15   ' final
ks = -5    ' step

REM draw axes
LINE (0, 240)-(640, 240), 8, , &H1111
LINE (320, 0)-(320, 480), 8, , &H1111

FOR k = ki TO kf STEP ks
        FOR i = 0 TO 10000
                rec = s * i: imc = 0
                GOSUB 500
                IF outside = 1 GOTO 100
        NEXT i
        END
100     vi = 1: vo = 2: vn = 3
        x(vi) = i - 1: x(vo) = i: x(vn) = i
        y(vi) = 0: y(vo) = 0: y(vn) = 1
        xi = x(vi)
        yi = y(vi)
        xo = x(vo)
        yo = y(vo)
        PSET (xc + x(vi) + x0, -y(vi) + y0), k
200     rec = s * x(vn) + recen: imc = s * y(vn) + imcen
        GOSUB 500
        IF outside = 1 GOTO 300
        LINE -(xc + x(vn) + x0, -y(vn) + y0)
        vt = vi: vi = vn: vn = vt
        GOTO 400
300     vt = vo: vo = vn: vn = vt
400     x(vn) = x(vi) + x(vo) - x(vt)
        y(vn) = y(vi) + y(vo) - y(vt)
        IF x(vi) <> xi OR y(vi) <> yi GOTO 200
        IF x(vo) <> xo OR y(vo) <> yo GOTO 200
        NEXT k
END
500     outside = 1

re = rec: im = imc
FOR j = 0 TO 2 - k
        re2 = re * re: im2 = im * im
        IF re2 + im2 > 256! THEN RETURN
        im = 2 * re * im + imc
        re = re2 - im2 + rec
        NEXT j
        outside = 0
        RETURN


