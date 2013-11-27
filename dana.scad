piece_radius = 120;
piece_thickness = 3;
band_thickness = 12;
band_min = 5;
band_gap = 6;
tri_thickness = 17;
tri_gap = 6;
gap = 2;

module triangle(r, h) {
    polyhedron(
        points = [ [0,r,0],
                   [r*cos(30), -1*r*sin(30), 0],
                   [-1*r*cos(30), -1*r*sin(30), 0],
                   [0,r,h],
                   [r*cos(30), -1*r*sin(30), h],
                   [-1*r*cos(30), -1*r*sin(30), h]
                 ],
        triangles = [ [0,1,2], [3,5,4],
                      [0,2,3], [2,5,3],
                      [2,1,5], [1,4,5],
                      [1,0,3], [4,1,3]
                    ]
    );
}

module tri_bar(r, h, t) {
    difference() {
        triangle(r,h);
        triangle(r-t, h);
    }
}

difference() {
    cylinder(r=piece_radius, h=piece_thickness);
    union() {
        cylinder(r=piece_radius - band_thickness, h=piece_thickness);
        triangle(r=piece_radius-band_min, h=piece_thickness);
        rotate([0,0,180]) {
            triangle(r=piece_radius-band_min, h=piece_thickness);
        }
    }
}
tri1_r = piece_radius - band_min - band_gap;
tri2_r = tri1_r - (tri_thickness + tri_gap);
tri3_r = tri2_r - (tri_thickness + tri_gap);
tri4_r = tri3_r - (tri_thickness + tri_gap);

union() {
    tri_bar(r=tri1_r, h=piece_thickness, t=tri_thickness);
    rotate([0,0,180]) {
        tri_bar(r=tri1_r, h=piece_thickness, t=tri_thickness);
    }
}

/* Inside cut-throughs */

r = tri1_r - tri_thickness - gap/2;
x = (r - (r * sin(30))) * tan(30);
y = r * sin(30);
for (angle = [0, 60, 120, 180, 240, 300]) {
    rotate([0,0,angle]) {
        translate([x,y,0]) {
            rotate([0,0,30]) {
                cube(size=[gap,tri_thickness+tri_gap,piece_thickness*2], center=true);
            }
        }
    }
}

/* Outside cut-throughts */
r = tri1_r + cos(30) *gap;
x = (r - (r * sin(30))) * tan(30);
y = r * sin(30);
for (angle = [0, 60, 120, 180, 240, 300]) {
    rotate([0,0,angle]) {
        translate([x,y,0]) {
            rotate([0,0,30]) {
                cube(size=[gap,tri_thickness+tri_gap,piece_thickness*2], center=true);
            }
        }
    }
}

tri_bar(r=tri2_r, h=piece_thickness, t=tri_thickness);
/*
rotate([0,0,180]) {
    tri_bar(r=tri2_r, h=piece_thickness, t=tri_thickness);
}
*/

/*
tri_bar(r=tri3_r, h=piece_thickness, t=tri_thickness);
rotate([0,0,180]) {
    tri_bar(r=tri3_r, h=piece_thickness, t=tri_thickness);
}

tri_bar(r=tri4_r, h=piece_thickness, t=tri_thickness);
rotate([0,0,180]) {
    tri_bar(r=tri4_r, h=piece_thickness, t=tri_thickness);
}
*/

