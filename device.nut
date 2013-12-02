// Serial RGB button matrix

local CS = hardware.pin2;
local MISO = hardware.pin1;
local MOSI = hardware.pin5;
local SCK = hardware.pin7;

CS.configure(DIGITAL_OUT);
MISO.configure(DIGITAL_OUT);
MOSI.configure(DIGITAL_IN);
SCK.configure(DIGITAL_OUT);

CS.write(0);
imp.sleep(0.1);

// Frame buffer for lights
local lights = 16;
local depth = 3;
local buf0 = [0,0,0]; local buf1 = [0,0,0]; local buf2 = [0,0,0]; local buf3 = [0,0,0];
local buf4 = [0,0,0]; local buf5 = [0,0,0]; local buf6 = [0,0,0]; local buf7 = [0,0,0];
local buf8 = [0,0,0]; local buf9 = [0,0,0]; local buf10 = [0,0,0]; local buf11 = [0,0,0];
local buf12 = [0,0,0]; local buf13 = [0,0,0]; local buf14 = [0,0,0]; local buf15 = [0,0,0];

local wait = 0;
local ready = 1;

function blank() {
    
  local d = 0;
    
  // init frame buffer
    for(d = 0; d < depth; d++) {
       buf0[d] = 0; buf1[d] = 0; buf2[d] = 0; buf3[d] = 0; buf4[d] = 0; buf5[d] = 0; buf6[d] = 0; buf7[d] = 0; 
       buf8[d] = 0; buf9[d] = 0; buf10[d] = 0; buf11[d] = 0; buf12[d] = 0; buf13[d] = 0; buf14[d] = 0; buf15[d] = 0;
    }

}

function writeByte(data) {
    for(local i = 0; i < 8; i++) {
        SCK.write(0);
        imp.sleep(0.000005);
 
        local dataToWrite = ((data & (1 << i)) >> i);
        MISO.write(dataToWrite);     
        imp.sleep(0.000005);
    
        SCK.write(1);
        imp.sleep(0.00001);
    }
}

// Read a byte.
// Returns the value for a single button.
// Non-zero if it is pressed, or 0 otherwise.
function readByte() {
    local result = 0;
    for(local i = 0; i < 8; i++) {  
        SCK.write(0);
        imp.sleep(0.000005);
          
        local readVal = MOSI.read();
        local readOut = 0;
        
        if (readVal == 1){
            readOut = 0;
        } else {
            readOut = 1;
        }
        
        result = result + (readOut * i);
        imp.sleep(0.000005);

        SCK.write(1);
        imp.sleep(0.00001);
    }
    return result;
}

function mainLoop(){
    
    local d = 0;
    
    SCK.write(1);
    CS.write(1);
    imp.sleep(0.000015);
    
    d = 0;
    writeByte(buf0[d]); writeByte(buf1[d]); writeByte(buf2[d]); writeByte(buf3[d]); writeByte(buf4[d]); writeByte(buf5[d]); writeByte(buf6[d]); writeByte(buf7[d]); 
    writeByte(buf8[d]); writeByte(buf9[d]); writeByte(buf10[d]); writeByte(buf11[d]); writeByte(buf12[d]); writeByte(buf13[d]); writeByte(buf14[d]); writeByte(buf15[d]);
  
    d = 1;
    writeByte(buf0[d]); writeByte(buf1[d]); writeByte(buf2[d]); writeByte(buf3[d]); writeByte(buf4[d]); writeByte(buf5[d]); writeByte(buf6[d]); writeByte(buf7[d]); 
    writeByte(buf8[d]); writeByte(buf9[d]); writeByte(buf10[d]); writeByte(buf11[d]); writeByte(buf12[d]); writeByte(buf13[d]); writeByte(buf14[d]); writeByte(buf15[d]);
   
    d = 2;
    writeByte(buf0[d]); writeByte(buf1[d]); writeByte(buf2[d]); writeByte(buf3[d]); writeByte(buf4[d]); writeByte(buf5[d]); writeByte(buf6[d]); writeByte(buf7[d]); 
    writeByte(buf8[d]); writeByte(buf9[d]); writeByte(buf10[d]); writeByte(buf11[d]); writeByte(buf12[d]); writeByte(buf13[d]); writeByte(buf14[d]); writeByte(buf15[d]);

    if(ready == 0) {
        wait = 1;
        ready = 1;
    }
    
    // Read the buttons: 16 bytes.
    for(local l = 0; l < lights; l++) {
        // readByte returns a non-zero value when a button is pressed.
        local b = readByte();
    
        // If a button is pressed, change the colour.
        if (b > 0 && ready && !wait) {

            //do something here
            
            // Change colours slowly.
            ready = 0;
        }
    }
    
    CS.write(0);
  
     // After the second cycle, get ready to read new button clicks.
    if(wait == 1) {
        imp.sleep(0.05);
        wait = 0;
        ready = 1;
    }
    
    imp.sleep(0.0004);
    
    imp.onidle(mainLoop);
        
}

function randomCols() {
    
    local d = 0;     
    buf0[d] = 7; buf1[d] = 7; buf2[d] = 5; buf3[d] = 0; buf4[d] = 0; buf5[d] = 0; buf6[d] = 5; buf7[d] = 3; 
    buf8[d] = 0; buf9[d] = 0; buf10[d] = 3; buf11[d] = 3; buf12[d] = 4; buf13[d] = 2; buf14[d] = 7; buf15[d] = 4;
       
    d = 1;
    buf0[d] = 3; buf1[d] = 1; buf2[d] = 7; buf3[d] = 8; buf4[d] = 7; buf5[d] = 7; buf6[d] = 7; buf7[d] = 7; 
    buf8[d] = 0; buf9[d] = 7; buf10[d] = 4; buf11[d] = 2; buf12[d] = 0; buf13[d] = 0; buf14[d] = 0; buf15[d] = 0;
       
    d = 2;
    buf0[d] = 0; buf1[d] = 0; buf2[d] = 2; buf3[d] = 7; buf4[d] = 3; buf5[d] = 0; buf6[d] = 0; buf7[d] = 3; 
    buf8[d] = 4; buf9[d] = 2; buf10[d] = 1; buf11[d] = 1; buf12[d] = 1; buf13[d] = 5; buf14[d] = 2; buf15[d] = 0;

}


imp.configure("RGB Matrix", [], []);

server.log("Booting!");

randomCols();

mainLoop();
