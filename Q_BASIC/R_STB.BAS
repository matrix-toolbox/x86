REM 1996

A = 130
H = A * SQR(3) / 2
DIM power(10) AS INTEGER
0 INPUT ; "1-10"; E%: IF E% < 1 OR E% > 10 THEN CLS : GOTO 0

t = 1
FOR i% = 0 TO E% - 1
    power(i%) = dimension%
    dimension% = dimension% + t
    t = t + t + t
    NEXT

DIM ax(dimension%) AS INTEGER, ay(dimension%) AS INTEGER

IF dimension% = 1 GOTO 1

n% = 1
p% = 1

WHILE n% < dimension%
      IF f% = power(q%) THEN
      vector3 = H / p%
      vector4 = A / p%
      q% = q% + 1
      p% = p% + p%
      ELSE
      ax(n%) = ax(f%)
      ay(n%) = ay(f%) - vector3
      ax(n% + 1) = ax(f%) - vector4
      ay(n% + 1) = ay(f%) + vector3
      ax(n% + 2) = ax(f%) + vector4
      ay(n% + 2) = ay(n% + 1)
      f% = f% + 1
      n% = n% + 3
      END IF
      WEND

1 SCREEN 11

FOR ptr1% = 0 TO E% - 1
    s% = 1
    te% = 2
    FOR l% = 1 TO ptr1%
        s% = s% + s% + s%
        te% = te% + te%
        NEXT
    vector1 = A / te%
    vector2 = H / te%
    FOR c% = 1 TO s%
        x = ax(index%) + 320
        y = ay(index%) + 230
        index% = index% + 1
        line1 = x - vector1
        line2 = y + 2 * vector2
        line3 = x + vector1
        PSET (x, y)
        LINE -(line1, line2)
        LINE -(line3, line2)
        LINE -(x, y)
        NEXT
    NEXT

    SLEEP

REM ORIGINAL CODE
REM 1996 A_BBS
REM DEFINT A-Z:SCREEN 11:a=130:h=a*SQR(3)/2:INPUT;"1-10";E
REM t=1:DO:V=V+t:I=I+1:Q(I)=V:IF I=E THEN EXIT DO
REM t=t+t+t:LOOP:DIM x(V),y(V):IF V=1 GOTO 3
REM n=1:P=1
REM 2 u=h/P:I=a/P:Q=Q+1:P=P+P:DO:x(n)=x(F):y(n)=y(F)-u:x(n+1)=x(F)-I
REM y(n+1)=y(F)+u:x(n+2)=x(F)+I:y(n+2)=y(n+1):n=n+3:IF n=V GOTO 3
REM F=F+1:IF F=Q(Q) GOTO 2
REM LOOP
REM 3 FOR o=0 TO E-1:s=1:t=2:FOR l=1TO o:s=s+s+s:t=t+t:NEXT:z=a/t:w=h/t
REM FOR c=1 TO s:x=x(m)+320:y=y(m)+230:m=m+1:j=x-z:l=x+z:g=y+w+w:PSET(x,y)
REM LINE-(j,g):LINE-(l,G):LINE-(x,Y):NEXT c,O

