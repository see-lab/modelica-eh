within EnergyHub.Examples.Data;
record EconomicParameters
  "Design parameters for economic aspects of the case study"
  // General economic parameters
  parameter Integer n = 20
    "Analysis period for calculating life cycle costs";
  parameter Real i = 0.03
    "Interest rate";
  parameter Real PA = ((1+i)^n-1)/(i*(1+i)^n)
    "Uniform series present worth factor";
  // grid power exchange price (euro/J conversion for standard SI unit)
  parameter Real gridSellPrice(unit="1/J")=0.1/3.6e6 "100 Eur/MWh";
  parameter Real gridBuyPrice(unit="1/J")=0.15/3.6e6 "130 Eur/MWh";

  // Electrical system costs
  // PV
  parameter Modelica.Units.SI.Area PV_surface=7 "PV surface area (m^2)";
  parameter Real capExOnePV=400*PV_surface
    "Capital cost for one PV panel (euro/panel)";

  // Battery
  parameter Real capExBat(unit="1/J")=1098/3.6e6
    "Capital cost of the battery (euro/J)";

  // Thermal system costs
  // Pumps
  parameter Real capExPum(unit="h/m3") = 35*3600/1000
    "Capital cost of the pumps 35 Eur/m^3/h)";
  // Heat pumps
  parameter Real capExHeaPum(unit="1/J") = 900/3.6e6
    "Capital cost of the heat pumps (Eur/J)";
  // Pipes
  parameter Real capExPip(unit="1/m") = 0
    "Capital cost of the pipes (Eur/m)";

  // Cost parameters to be set in higher-level models
  parameter Real CCap "Capital cost (principal)";

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
end EconomicParameters;
