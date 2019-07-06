//*************************************************************************************************
//
// Solid Fuel Booster auto and simple recovery tool
//
// ================================================================================================
//
// History
// --------
// v1.0        First release
//
//*************************************************************************************************

//=================================================================================================
// N O T I C E
//
// 1/ This script has the following purpose
//    - Wait until booster is decoupled from the main vessel
//    - Trigger the BRAKES action group, it will deploy aerobrakes if any
//    - As soon as the safe condition are met to deploy chutes, do it.
//
// 2/ This script needs
//    - Once decoupled the boosters must be a vessel, not a debris. You need a command pod somewhere
//      in your booster.
//
// 3/ This script does not
//    - Do any calculations and course corrections to match a landing point
//    - Perform any slowing burn at any time
//    - Deploy landing gear because this script assume your booster will dive in the ocean
//    - is not responsible of bad engineered boosters which will crash onto the surface because the
//      velocity is too high.
//
//=================================================================================================


CLEARSCREEN.
print "Booster Script has started".

// Wait for booster to be empty of solid fuel.
// Note that it totally works while the booster is attached to a central core.
// When decoupled the booster will be a separate vessel and the drymass = mass condition will have
// a better chance to become true
//
// I was forced to use this formula because I noticed while debugging that the values are never equal
UNTIL ABS(SHIP:DRYMASS - SHIP:MASS) < 0.1
{
    wait 5. // We are not in a hurry to detect when the booster is decoupled
    print "drymass= " + SHIP:DRYMASS + " mass " + SHIP:MASS.
}

print "--- BOOSTER IS NOW EMPTY ---".
SAS OFF. // Let the aero forces do their job.

BRAKES ON.
print "--- BRAKES DEPLOYED IF ANY ---".

// Now checking the chute condition in the background while the script continues
// Check the WHEN instruction in the KOS documentation for more details.
WHEN (NOT CHUTESSAFE) THEN
{
	print "--- CHUTES DEPLOYED ---".
    CHUTESSAFE ON.
    RETURN (NOT CHUTES).
}


UNTIL SHIP:ALTITUDE < 1
{
    print "airspeed is " +  ROUND(SHIP:AIRSPEED) + " altitude is " +  ROUND(SHIP:ALTITUDE).
    wait 2.
}

print "--- BOOSTER HAS LANDED! ---".
