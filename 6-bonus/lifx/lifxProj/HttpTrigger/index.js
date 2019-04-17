/*

Function      : HttpTrigger
Type          : Azure Function HTTP Trigger
Language      : JavaScript/Node.js

Purpose       : Manage LIFX Smart Wifi Lights

Dependencies  : "bearerToken" defined within Azure Application Settings (obtained from LIFX Developer API)
                npm packages: axios, lifx-http-api, ms-rest, ms-rest-azure
                npm init -y
                npm install axios --save
                npm install lifx-http-api --save
                npm install ms-rest --save
                npm install ms-rest-azure --save

Author        : Jason Vriends (jason@thevriends.com)

References    : Lifx HTTP API                 https://api.developer.lifx.com/docs/introduction
              : Lifx HTTP Api Node.js Wrapper https://github.com/klarstil/lifx-http-api
              : Azure Functions Core Tools    https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local

*/

'use strict';

// Packages
const axios = require('axios');
const lifx = require('lifx-http-api');

// Variables
const client = new lifx({bearerToken: process.env.lifxPersonalAccessToken});

module.exports = async function (context, req) {

    context.log('lifxHttpTriggerFunc function received a request.');

    function lifxSetState(reqSelector, { optPower, optColor, optBrightness, optDuration } = { }) {

        /*

        [string]  reqSelector       : The selector to limit which lights will run the effect.
        [string]  optPower          : The power state you want to set on the selector (on or off).
        [string]  optColor          : The color to use for the effect.
        [string]  optBrightness     : The brightness level from 0.0 to 1.0 when the effect ends.
        [double]  optDuration       : How long in seconds you want the power action to take. Range: 0.0 to 3155760000.0 (100 years)
        
        https://api.developer.lifx.com/docs/set-state

        */

        context.log.info ('enter function: lifxSetState');

        if (optBrightness != null) {
            optColor = optColor + ' brightness:'+optBrightness;
        }

        // Build lifx state object
        var lifxState = {};
        lifxState.power = optPower;
        lifxState.color = optColor;
        lifxState.duration = optDuration;

        // Output lifx state object
        context.log.info(JSON.stringify(lifxState));

        // Return result of LIFX setState method
        context.log.info ('exit function: lifxSetState');
        return client.setState(`${reqSelector}`, lifxState);

    }

    function lifxEffectBreathe(reqSelector, reqEffect, reqColor, { optBrightness, optBrightnessFrom, optFromcolor, optPeriod, optCycles, optPersist, optPeak } = { }) {

        /*

        [string]  reqSelector       : The selector to limit which lights will run the effect.
        [string]  reqEffect         : The effect (breathe or pulse)
        [string]  reqColor          : The color to use for the effect.
        [string]  optBrightness     : The brightness level from 0.0 to 1.0 when the effect ends.
        [string]  optBrightnessFrom : The brightness level from 0.0 to 1.0 when the effect starts.
        [string]  optFromcolor      : The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.
        [double]  optPeriod         : The time in seconds for one cycle of the effect.
        [double]  optCycles         : The number of times to repeat the effect.
        [boolean] optPersist        : If false set the light back to its previous value when effect ends, if true leave the last effect color.
        [double]  optPeak           : Defines where in a period the target color is at its maximum
        
        https://api.developer.lifx.com/docs/breathe-effect

        */

        context.log.info ('enter function: lifxEffectBreathe');

        // Build lifx state object

        if (optBrightness != null) {
            reqColor = reqColor + ' brightness:'+optBrightness;
        } else {
            reqColor = reqColor + ' brightness:1';
        }

        if (optFromcolor == null || optBrightnessFrom == null) {
            optFromcolor = reqColor + ' brightness:0.25';
        }

        if (optBrightnessFrom != null) {
            optFromcolor = optFromcolor + ' brightness:'+optBrightnessFrom;
        }

        var lifxState = {};
        lifxState.color = reqColor;
        lifxState.from_color = optFromcolor;
        lifxState.period = optPeriod;
        lifxState.cycles = optCycles;
        lifxState.persist = optPersist;
        lifxState.peak = optPeak;
        lifxState.power_on = true;

        // Output lifx state object
        context.log.info(JSON.stringify(lifxState));

        // Return result of LIFX breathe method
        context.log.info ('exit function: lifxEffectBreathe');
        return client.breathe(`${reqSelector}`, lifxState);

    }

    function lifxEffectPulse(reqSelector, reqEffect, reqColor, { optBrightness, optBrightnessFrom, optFromcolor, optPeriod, optCycles, optPersist, optPeak } = { }) {

        /*

        [string]  reqSelector       : The selector to limit which lights will run the effect.
        [string]  reqEffect         : The effect (breathe or pulse)
        [string]  reqColor          : The color to use for the effect.
        [string]  optBrightness     : The brightness level from 0.0 to 1.0 when the effect ends.
        [string]  optBrightnessFrom : The brightness level from 0.0 to 1.0 when the effect starts.
        [string]  optFromcolor      : The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.
        [double]  optPeriod         : The time in seconds for one cycle of the effect.
        [double]  optCycles         : The number of times to repeat the effect.
        [boolean] optPersist        : If false set the light back to its previous value when effect ends, if true leave the last effect color.
        [double]  optPeak           : Defines where in a period the target color is at its maximum
        
        https://api.developer.lifx.com/docs/pulse-effect

        */

        context.log.info ('enter function: lifxEffectPulse');

        // Build lifx state object

        if (optBrightness != null) {
            reqColor = reqColor + ' brightness:'+optBrightness;
        } else {
            reqColor = reqColor + ' brightness:1';
        }

        if (optFromcolor == null || optBrightnessFrom == null) {
            optFromcolor = reqColor + ' brightness:0.25';
        }

        if (optBrightnessFrom != null) {
            optFromcolor = optFromcolor + ' brightness:'+optBrightnessFrom;
        }

        var lifxState = {};
        lifxState.color = reqColor;
        lifxState.from_color = optFromcolor;
        lifxState.period = optPeriod;
        lifxState.cycles = optCycles;
        lifxState.persist = optPersist;
        lifxState.peak = optPeak;
        lifxState.power_on = true;

        // Output lifx state object
        context.log.info(JSON.stringify(lifxState));

        // Return result of LIFX breathe method
        context.log.info ('exit function: lifxEffectPulse');
        return client.pulse(`${reqSelector}`, lifxState);

    }    

    // Parameters
    var selector = req.query.selector;
    var power = req.query.power;
    var color = req.query.color; 
    var effect = req.query.effect;
    var brightness = req.query.brightness;
    var brightnessfrom = req.query.brightnessfrom;
    var fromcolor = req.query.fromcolor;
    var period = parseFloat(req.query.period);
    var cycles = parseFloat(req.query.cycles);
    var persist = Boolean(req.query.persist);
    var peak = parseFloat(req.query.peak);
    var duration = parseFloat(req.query.duration);

    // Main
    if (selector) {

        var output;


        // effect=none
        if (effect == null) {
            output = await lifxSetState(selector, {optPower: power, optColor:color, optBrightness: brightness, optDuration:duration });  
        }
        
        // effect=breathe
        else if (effect == "breathe") {
            output = await lifxEffectBreathe(selector, effect, color, { optBrightness: brightness, optBrightnessFrom: brightnessfrom, optFromcolor:fromcolor, optPeriod:period, optCycles: cycles, optPersist:persist, optPeak:peak });    
        }

        // effect=pulse
        else if (effect == "pulse") {
            output = await lifxEffectPulse(selector, effect, color, { optBrightness: brightness, optBrightnessFrom: brightnessfrom, optFromcolor:fromcolor, optPeriod:period, optCycles: cycles, optPersist:persist, optPeak:peak });    
        }

        context.log("Output: " + JSON.stringify(output));
        // Output results as JSON to body
        context.res = {
            status: 200,
            body: output
        };

    } else {

        // Output syntax as JSON to body
        context.res = {
            status: 400,
            body: "lifxHttpTriggerFunc: please provide the required parameters."
        };
    
    }

};