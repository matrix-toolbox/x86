REM MANDELBROT SET
REM
REM 1994-11-01
REM
REM BASED ON THE ATARI ROUTINE
REM THE VERY FIRST ATTEMPT TO GENERATE THE MANDELBROT SET
REM ORIGINALLY RUN ON ATARI800XL THAT SUNDAY FOR HOURS AND HOURS...

SCREEN 11
 xs = .355833
 ys = .331399
WHILE INKEY$ = ""
      x = x1
      y = y1
      x1 = x * x - y * y + xs
      y1 = 2 * x * y + ys
      PSET (x * 1700, y * 1700 - 600)
      WEND

' SCREEN 11: REM 1994 HENON
' DO: a = .3 * y + 1 - 1.4 * x * x: b = x
'     PSET (x * 180 + 300, y * 180 + 240): x = a: y = b
'     LOOP

' STRANGELETS
' -----------

'  PSEUDO "BIFURCATIONS"
'  n = r * SIN(o) * ATN(o) * COS(r + o) - 1
'  r = r + 0.001
'  PSET(r * 40, n * 10 + 200), (n + o) / 2
'  o = n
'
'  n = r * SIN(o) XOR COS(r + o)
'  r = r + 0.001
'  PSET(r * 40, n * 10 + 200)
'  o = n
'
'  n = r * SIN(o) * COS(r - o) - 1
'  m = r * ATN(o + r) ' + COS(r - o)
'  r = r + 0.006
'  PSET(r * 40, n + m * 10 + 200)
'  o = n

