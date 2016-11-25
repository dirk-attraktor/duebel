$fn = 36;

/////////////////////////////////////////
//   SETTINGS  

MaterialThickness = 3;
HoleDiameter = 1.8; 

HoleOffset = MaterialThickness/2; // center 
//HoleOffset = (HoleDiameter/2)  + 2; // offset by distance between hole and material egde

Width = 4.9;
Height = Width-0.1; // luft lassen

/////////////////////////////////////////


min_print_cap = 0.8; // min printable size

nupsiunten_x = max(min_print_cap,MaterialThickness/6.0);
nupsiunten_y = nupsiunten_x;
echo("nupsiunten_x" , nupsiunten_x);
echo("nupsiunten_y" , nupsiunten_y);

nupsioben_x = nupsiunten_x * 0.8;
//nupsioben_y = nupsioben_x + max(HoleOffset,MaterialThickness) - MaterialThickness +  HoleDiameter/5;
nupsioben_y = max(nupsiunten_y*1.2,(HoleOffset + HoleDiameter/2 + 1  ) - MaterialThickness);

echo("nupsioben_x" , nupsioben_x);
echo("nupsioben_y" , nupsioben_y);
nutbreite = max(nupsioben_x*1.2,max(min_print_cap,HoleDiameter*0.3));

echo("nutbreite" , nutbreite);

nutsteghoehe = nupsiunten_y*1.2; // von ganz untens bis innenkante nut (da wo es sich verbiegt)

senkungstopdurchmesser = (HoleDiameter * 1.3) + 0.3; // schraubendurchmesser + einbautolleranz
senkungstiefe = 1.2;

difference() {
    basebox();
    loch();
}


module loch(){
    // loch
    translate([Width/2 , HoleOffset , -0.01]) {
        cylinder( Height+0.02 , HoleDiameter/2 , HoleDiameter/2 , false);
    }   
    // senkung
    translate([Width/2 , HoleOffset , Height - senkungstiefe]) {
        cylinder( senkungstiefe+0.01 , HoleDiameter/2, senkungstopdurchmesser/2, false);
    }   
   
    //translate([Width/2 , HoleOffset , -0.01]) {
    //    cylinder( senkungstiefe+0.01 ,  senkungstopdurchmesser/2, HoleDiameter/2,false);
    //}   
   
    //nut
    translate([((Width/2)-(nutbreite/2)),nutsteghoehe-nupsiunten_y,-0.01]) {
        cube([nutbreite,100,Height+0.02]);
    }
} 

module nupsisoben(){
    difference(){
        translate([-nupsioben_x,MaterialThickness,-0]) {
        cube([Width+nupsioben_x+nupsioben_x,nupsioben_y,Height]);
        };
        ecken();
    };
}

module ecken(){
    // rechts
    translate([0,0,-0.01]) {
        linear_extrude(100) {
            polygon(points=[
             [ Width+nupsioben_x + 0.01 , MaterialThickness - 0.01 ] ,
             [ Width+nupsioben_x + 0.01 , MaterialThickness + nupsioben_y / 2 ],
             [ Width - 0.4              , MaterialThickness + nupsioben_y + 0.01 ],
             [ Width+nupsioben_x + 0.01 , MaterialThickness + nupsioben_y + 0.01 ] 
            ]);
        };
    }
    //links
    translate([0,0,-0.01]) {
        linear_extrude(100) {
            polygon(points=[
             [ -nupsioben_x - 0.01 , MaterialThickness - 0.01 ],
             [ -nupsioben_x - 0.01 , MaterialThickness + nupsioben_y / 2 ],
             [  0 + 0.4            , MaterialThickness + nupsioben_y + 0.01 ],
             [ -nupsioben_x - 0.01 , MaterialThickness + nupsioben_y + 0.01 ],
            ]);
        };
    };
}
    
    
module basebox(){   
    cube([Width,MaterialThickness,Height]);

    // nupsiunten
    translate([-nupsiunten_x,-nupsiunten_y,0]) {
        cube([Width+nupsiunten_x+nupsiunten_x,nupsiunten_y,Height]);
    }
    nupsisoben();
}
