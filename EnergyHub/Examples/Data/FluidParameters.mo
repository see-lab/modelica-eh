within EnergyHub.Examples.Data;
record FluidParameters
  "Design parameters for the thermofluid aspects of the case study"
  parameter Real fac=dp_length_nominal/200 "Friction of lake pipe";
  parameter Integer nCon(min=0)=3 "Number of connected loads in the district model";
  // Heat pumps
  // COP
  parameter Real COP_heating = 3.59 "Space heating design COP, nominal";
  parameter Real COP_cooling = 4 "Space cooling design COP, nominal";
  parameter Real COP_DHW=3.5 "DHW design COP, nominal";

  // Temperature setpoints and limits
  parameter Modelica.Units.SI.Temperature TDisWatMin=6+273.15
    "District water minimum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDisWatMax=16+273.15
    "District water maximum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0)=4
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=38+273.15
    "Heating water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDhwtSup_nominal=49+273.15
    "DHW water temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TCooWatSup_nominal=7+273.15
    "Heating water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDomSup_nominal=20+273.15
    "Domestic water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TLakSup_nominal=6+273.15
    "Lake nominal supply temperature"
    annotation (Dialog(group="ETS model parameters"));

  // Pressure drop across various equipment legs
  parameter Modelica.Units.SI.Pressure dpLoa_nominal(displayUnit="Pa")=6000
    "Pressure difference at nominal flow rate on the load side"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Pressure dpDis_nominal(displayUnit="Pa")=6000
    "Pressure difference at nominal flow rate on the district side"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real dp_length_nominal(final unit="Pa/m") = 69.3
    "Pressure drop per pipe length at nominal flow rate";

  // Pipe lengths
  parameter Modelica.Units.SI.Length lLak=1000
    "Length of the distribution pipe to the lake and back from the loads (total)";
  parameter Modelica.Units.SI.Length lLakPum=50
    "Length of the distribution pipe from the district main pump to the lake";
  parameter Modelica.Units.SI.Length lWat=50
    "Length of the distribution pipe to the domestic water connection and back";
  parameter Modelica.Units.SI.Length lDis[nCon]=fill(50, nCon)
    "Length of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length lCon[nCon]=fill(10, nCon)
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length lEnd=sum(lDis)
    "Length of the end of the distribution line (after last connection)";

  // Parameters to be declared within model
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal
    "Mass flow rate for the district main (all connected loads)";
  parameter Modelica.Units.SI.MassFlowRate mLak_flow_nominal
    "Mass flow rate for the lake main";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Malihe Davari and Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end FluidParameters;
