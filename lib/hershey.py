#    This is a component of AXIS, a front-end for emc
#    Copyright 2005 Chris Radek <chris@timeguy.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

from OpenGL.GL import *

#        [[(180.0, 100.0), (220.0, 80.0), (280.0, 20.0), (280.0, 440.0)]], \

translate = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '-': 10, '.': 11}

class Hershey:
    def __init__(self):
        self.lists = glGenLists(10)
        self.hershey = \
        [[(240.0, 20.0), (180.0, 40.0), (140.0, 100.0), (120.0, 200.0),
          (120.0, 260.0), (140.0, 360.0), (180.0, 420.0), (240.0, 440.0),
          (280.0, 440.0), (340.0, 420.0), (380.0, 360.0), (400.0, 260.0),
          (400.0, 200.0), (380.0, 100.0), (340.0, 40.0), (280.0, 20.0),
          (240.0, 20.0)]], \
        [[(120.0, 100.0), (160.0, 80.0), (220.0, 20.0), (220.0, 440.0)]], \
        [[(140.0, 120.0), (140.0, 100.0), (160.0, 60.0), (180.0, 40.0),
          (220.0, 20.0), (300.0, 20.0), (340.0, 40.0), (360.0, 60.0),
          (380.0, 100.0), (380.0, 140.0), (360.0, 180.0), (320.0, 240.0),
          (120.0, 440.0), (400.0, 440.0)]], \
        [[(160.0, 20.0), (380.0, 20.0), (260.0, 180.0), (320.0, 180.0),
          (360.0, 200.0), (380.0, 220.0), (400.0, 280.0), (400.0, 320.0),
          (380.0, 380.0), (340.0, 420.0), (280.0, 440.0), (220.0, 440.0),
          (160.0, 420.0), (140.0, 400.0), (120.0, 360.0)]], \
        [[(320.0, 20.0), (120.0, 300.0), (420.0, 300.0)], [(320.0, 20.0),
          (320.0, 440.0)]], \
        [[(360.0, 20.0), (160.0, 20.0), (140.0, 200.0), (160.0, 180.0),
          (220.0, 160.0), (280.0, 160.0), (340.0, 180.0), (380.0, 220.0),
          (400.0, 280.0), (400.0, 320.0), (380.0, 380.0), (340.0, 420.0),
          (280.0, 440.0), (220.0, 440.0), (160.0, 420.0), (140.0, 400.0),
          (120.0, 360.0)]], \
        [[(380.0, 80.0), (360.0, 40.0), (300.0, 20.0), (260.0, 20.0),
          (200.0, 40.0), (160.0, 100.0), (140.0, 200.0), (140.0, 300.0),
          (160.0, 380.0), (200.0, 420.0), (260.0, 440.0), (280.0, 440.0),
          (340.0, 420.0), (380.0, 380.0), (400.0, 320.0), (400.0, 300.0),
          (380.0, 240.0), (340.0, 200.0), (280.0, 180.0), (260.0, 180.0),
          (200.0, 200.0), (160.0, 240.0), (140.0, 300.0)]], \
        [[(400.0, 20.0), (200.0, 440.0)], [(120.0, 20.0), (400.0, 20.0)]], \
        [[(220.0, 20.0), (160.0, 40.0), (140.0, 80.0), (140.0, 120.0),
          (160.0, 160.0), (200.0, 180.0), (280.0, 200.0), (340.0, 220.0),
          (380.0, 260.0), (400.0, 300.0), (400.0, 360.0), (380.0, 400.0),
          (360.0, 420.0), (300.0, 440.0), (220.0, 440.0), (160.0, 420.0),
          (140.0, 400.0), (120.0, 360.0), (120.0, 300.0), (140.0, 260.0),
          (180.0, 220.0), (240.0, 200.0), (320.0, 180.0), (360.0, 160.0),
          (380.0, 120.0), (380.0, 80.0), (360.0, 40.0), (300.0, 20.0),
          (220.0, 20.0)]], \
        [[(380.0, 160.0), (360.0, 220.0), (320.0, 260.0), (260.0, 280.0),
          (240.0, 280.0), (180.0, 260.0), (140.0, 220.0), (120.0, 160.0),
          (120.0, 140.0), (140.0, 80.0), (180.0, 40.0), (240.0, 20.0),
          (260.0, 20.0), (320.0, 40.0), (360.0, 80.0), (380.0, 160.0),
          (380.0, 260.0), (360.0, 360.0), (320.0, 420.0), (260.0, 440.0),
          (220.0, 440.0), (160.0, 420.0), (140.0, 380.0)]], \
        [[(100, 250), (350, 250)]], \
        [[(200, 450), (250, 450)]],

        for i in range(12):
            digit = self.hershey[i]
            glNewList(self.lists + i, GL_COMPILE)
            glColor3f(1,1,1)
            for stroke in digit:
                glBegin(GL_LINE_STRIP)
                for point in stroke:
                    glVertex3f(point[0], 500-point[1], 0)
                glEnd()
            glEndList()

    def plot_digit(self, n):
        glPushMatrix()
        glScalef(1/500.0, 1/500.0, 1/500.0)
        glCallList(self.lists + n)
        glPopMatrix()

    def plot_string(self, s, frac=0):
        if frac:
            len = self.string_len(s)
            glTranslatef(-len*frac, 0, 0)
        glPushMatrix()
        glScalef(1/500.0, 1/500.0, 1/500.0)
        for c in s:
            glCallList(self.lists + translate[c])
            if c == '1' or c == '.':
                glTranslatef(260, 0, 0)
            else:
                glTranslatef(400, 0, 0)
        glPopMatrix()

    def string_len(self, s):
        l = 0.0
        for c in s:
            if c == '1' or c == '.':
                l += 260.0
            else:
                l += 400.0

        return l/500.0

    def center_string(self, s):
        len = self.string_len(s)
        glTranslatef(-len/2, -.5, 0)
