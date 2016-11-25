$fn = 36;

// printer settings
min_print_cap = 0.8; // min printable size


plattendicke = 3;

bohrungdurchmesser = 1.8; 

bohrungsoffset = 1.5 + bohrungdurchmesser/2; // distanz aussenkante bis bohrloch
bohrungsoffset = plattendicke/2; // center 
//bohrungsoffset = 3; // some value

breite = 4.9;

hoehe = breite-0.1; // luft lassen

nupsiunten_x = max(min_print_cap,plattendicke/6.0);
nupsiunten_y = nupsiunten_x;
echo("nupsiunten_x" , nupsiunten_x);
echo("nupsiunten_y" , nupsiunten_y);


nupsioben_x = nupsiunten_x * 0.8;
//nupsioben_y = nupsioben_x + max(bohrungsoffset,plattendicke) - plattendicke +  bohrungdurchmesser/5;
nupsioben_y = max(nupsiunten_y*1.2,(bohrungsoffset + bohrungdurchmesser/2 + 1  ) - plattendicke);

echo("nupsioben_x" , nupsioben_x);
echo("nupsioben_y" , nupsioben_y);
nutbreite = max(nupsioben_x*1.2,max(min_print_cap,bohrungdurchmesser*0.3));

echo("nutbreite" , nutbreite);

nutsteghoehe = nupsiunten_y*1.2; // von ganz untens bis innenkante nut (da wo es sich verbiegt)

senkungstopdurchmesser = (bohrungdurchmesser * 1.3) + 0.3; // schraubendurchmesser + einbautolleranz
senkungstiefe = 1.2;

difference() {
    basebox();
    loch();
}


module loch(){
    // loch
    translate([breite/2 , bohrungsoffset , -0.01]) {
        cylinder( hoehe+0.02 , bohrungdurchmesser/2 , bohrungdurchmesser/2 , false);
    }   
    // senkung
    translate([breite/2 , bohrungsoffset , hoehe - senkungstiefe]) {
        cylinder( senkungstiefe+0.01 , bohrungdurchmesser/2, senkungstopdurchmesser/2, false);
    }   
   
    //translate([breite/2 , bohrungsoffset , -0.01]) {
    //    cylinder( senkungstiefe+0.01 ,  senkungstopdurchmesser/2, bohrungdurchmesser/2,false);
    //}   
   
    //nut
    translate([((breite/2)-(nutbreite/2)),nutsteghoehe-nupsiunten_y,-0.01]) {
        cube([nutbreite,100,hoehe+0.02]);
    }
} 

module nupsisoben(){
    difference(){
        translate([-nupsioben_x,plattendicke,-0]) {
        cube([breite+nupsioben_x+nupsioben_x,nupsioben_y,hoehe]);
        };
        ecken();
    };
}

module ecken(){
    // rechts
    translate([0,0,-0.01]) {
        linear_extrude(100) {
            polygon(points=[
             [ breite+nupsioben_x + 0.01 , plattendicke - 0.01 ] ,
             [ breite+nupsioben_x + 0.01 , plattendicke + nupsioben_y / 2 ],
             [ breite - 0.4              , plattendicke + nupsioben_y + 0.01 ],
             [ breite+nupsioben_x + 0.01 , plattendicke + nupsioben_y + 0.01 ] 
            ]);
        };
    }
    //links
    translate([0,0,-0.01]) {
        linear_extrude(100) {
            polygon(points=[
             [ -nupsioben_x - 0.01 , plattendicke - 0.01 ],
             [ -nupsioben_x - 0.01 , plattendicke + nupsioben_y / 2 ],
             [  0 + 0.4            , plattendicke + nupsioben_y + 0.01 ],
             [ -nupsioben_x - 0.01 , plattendicke + nupsioben_y + 0.01 ],
            ]);
        };
    };
}
    
    
module basebox(){   
    cube([breite,plattendicke,hoehe]);

    // nupsiunten
    translate([-nupsiunten_x,-nupsiunten_y,0]) {
        cube([breite+nupsiunten_x+nupsiunten_x,nupsiunten_y,hoehe]);
    }
    nupsisoben();
}