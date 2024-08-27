//semi_round_cube(size_x=10,size_y=10,size_z=10,diameter=1,center=true);

//round_cylinder(height=10, r1 = 10, fillet = 2);

module external_cylinder_fillet(
    r,
    fillet
) {
    $fn=100;
    rotate_extrude() {
        translate([r,0,0])
            difference() {
                square(size=fillet);
                translate([fillet,0,0])circle(r=fillet);
            }
    }
}

module round_cylinder(
    height,
    r1,
    r2,
    fillet
){
    $fn=100;
    r2 = is_undef(r2) ? r1 : r2;
    hull() {
        translate([0,0,fillet]) rotate_extrude()
            translate([r1-fillet,0,0])circle(r=fillet);
        translate([0,0,height-fillet])
            rotate_extrude()
                translate([r2-fillet,0,height])circle(r=fillet);
    }

}

module round_cube(
    size_x,
    size_y,
    size_z,
    fillet,
    center=false
) {
    $fn=100;
    translate_x = center ? fillet - size_x/2 : fillet;
    translate_y = center ? fillet - size_y/2 : fillet;
    translate_z = center ? fillet - size_z/2 : fillet;

    echo(translate_x, translate_y,translate_z);
    
    translate([translate_x,translate_y,translate_z])
        minkowski() {
            cube([size_x-2*fillet, size_y-2*fillet, size_z-2*fillet]);
            sphere(r=fillet);
        }
}

module semi_round_cube(
    size_x,
    size_y,
    size_z,
    fillet,
    center=false  
) {
    $fn=100;
    translate_x = center ? fillet - size_x/2 : fillet;
    translate_y = center ? fillet - size_y/2 : fillet;
    translate_z = center ? - size_z/2 : 0;
    translate([translate_x,translate_y,translate_z])
        render()
            minkowski() {
                cube([size_x-2*fillet, size_y-2*fillet, size_z-0.01]);
                cylinder(h=0.01,r=fillet);
            }
}

module custom_rectangle(
    size_z,                 // Heigth on Z axis
    base_size_x1,           // Bottom size on X axis
    base_size_y1,           // Bottom size on Y axis 
    diameter1,              // Diameter for bottom round corner 
    base_size_x2,           // Top size on X axis (optional)
    base_size_y2,           // Top size on Y axis (optional)
    diameter2,              // Diameter for top round corner (optional)
    sphere_corner = false,  // Sphere or cylinder
    round_corner_x0_y0 = true,      // bottom low left     
    round_corner_x0_y1 = true,      // bottom high left
    round_corner_x1_y1 = true,      // bottom high right
    round_corner_x1_y0 = true,      // bottom low right 
    round_corner_x2_y2 = true,      // top low left 
    round_corner_x2_y3 = true,      // top high left 
    round_corner_x3_y3 = true,      // top high right
    round_corner_x3_y2 = true       // top low right
    
) {
    // set default value if not provided
    base_size_x2 = is_undef(base_size_x2) ? base_size_x1 : base_size_x2;
    base_size_y2 = is_undef(base_size_y2) ? base_size_y1 : base_size_y2;
    diameter2 = is_undef(diameter2) ? diameter1 : diameter2;

    // set diameters
    diameter_x0_y0 = round_corner_x0_y0 ? diameter1 : 0.001;
    diameter_x0_y1 = round_corner_x0_y1 ? diameter1 : 0.001;
    diameter_x1_y1 = round_corner_x1_y1 ? diameter1 : 0.001;
    diameter_x1_y0 = round_corner_x1_y0 ? diameter1 : 0.001;
    
    diameter_x2_y2 = round_corner_x2_y2 ? diameter2 : 0.001;
    diameter_x2_y3 = round_corner_x2_y3 ? diameter2 : 0.001;
    diameter_x3_y3 = round_corner_x3_y3 ? diameter2 : 0.001;
    diameter_x3_y2 = round_corner_x3_y2 ? diameter2 : 0.001;

    
    // Coordinates for bottom of the shape
    
    x0_y0 = -base_size_x1/2 + diameter_x0_y0/2;
    y0_x0 = -base_size_y1/2 + diameter_x0_y0/2;
    
    x1_y0 = base_size_x1/2 - (diameter_x1_y0/2);
    y0_x1 = -base_size_y1/2 + diameter_x1_y0/2;
    
    x1_y1 = base_size_x1/2 - (diameter_x1_y1/2);
    y1_x1 = base_size_y1/2 - (diameter_x1_y1/2);
    
    x0_y1 = -base_size_x1/2 + diameter_x0_y1/2;
    y1_x0 = base_size_y1/2 - (diameter_x0_y1/2);
    
    // Coordinates for top of the shape
    x2_y2 = -base_size_x2/2 + diameter_x2_y2/2;
    y2_x2 = -base_size_y2/2 + diameter_x2_y2/2;
    
    x2_y3 = -base_size_x2/2 + diameter_x2_y3/2;
    y3_x2 = base_size_y2/2 - (diameter_x2_y3/2);
    
    x3_y3 = base_size_x2/2 - (diameter_x3_y3/2);
    y3_x3 = base_size_y2/2 - (diameter_x3_y3/2);
    
    x3_y2 = base_size_x2/2 - (diameter_x3_y2/2);
    y2_x3 = -base_size_y2/2 + diameter_x3_y2/2;
    
    height = 0.001;
    
    $fn = 20;
    
    // Create figure
    hull() {
        
        if (sphere_corner) {
            // bottom
            color("blue", 1.0)
            translate([x0_y0,y0_x0,diameter_x0_y0/2])
                sphere(d = diameter_x0_y0);
            translate([x1_y0,y0_x1,diameter_x1_y0/2])
                sphere(d = diameter_x1_y0);
            translate([x1_y1,y1_x1,diameter_x1_y1/2])
                sphere(d = diameter_x1_y1);
            translate([x0_y1,y1_x0,diameter_x0_y1/2])
                sphere(d = diameter_x0_y1);
            
            // top
            color("orange", 1.0)
            translate([x2_y2,y2_x2,size_z - diameter_x2_y2/2])        
                sphere(d = diameter_x2_y2);
            translate([x3_y2,y2_x3,size_z - diameter_x3_y2/2])
                sphere(d = diameter_x3_y2);
            translate([x3_y3,y3_x3,size_z - diameter_x3_y3/2])
                sphere(d = diameter_x3_y3);
            translate([x2_y3,y3_x2,size_z - diameter_x2_y3/2])
                sphere(d = diameter_x2_y3);
        }
        else {
        
            // bottom
            color("blue", 1.0)
            translate([x0_y0,y0_x0,0])
                cylinder(h = height, d = diameter_x0_y0);
            translate([x1_y0,y0_x1,0])
                cylinder(h = height, d = diameter_x1_y0);
            translate([x1_y1,y1_x1,0])
                cylinder(h = height, d = diameter_x1_y1);
            translate([x0_y1,y1_x0,0])
                cylinder(h = height, d = diameter_x0_y1);
            
            // top
            color("orange", 1.0)
            translate([x2_y2,y2_x2,size_z])        
                cylinder(h = height, d = diameter_x2_y2);
            translate([x3_y2,y2_x3,size_z])
                cylinder(h = height, d = diameter_x3_y2);
            translate([x3_y3,y3_x3,size_z])
                cylinder(h = height, d = diameter_x3_y3);
            translate([x2_y3,y3_x2,size_z])
                cylinder(h = height, d = diameter_x2_y3);
        }
    }
}



function get_gridfinity_size(number_of_block) = number_of_block * standard_size - 0.5;
function get_diameter(a, b) = sqrt((a*a)+(b*b));