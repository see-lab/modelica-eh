within EnergyHub.Examples.Data;
record ElectricalParameters
  "Design parameters for the electrical aspects of the case study"
  // General electrical system
  parameter Real pfLoa=0.8 "Power factor for the loads overall";
  parameter Modelica.Units.SI.Voltage V_nominal=230 "RMS voltage of the source";

 // PV panels
  parameter Real PV_eff=0.19 "PV efficiency";
  parameter Real nPV(min=0) = 5000 "Number of PV arrays";

 // Battery energy storage system
  parameter Real etaBatDis=0.98
    "Electrical storage discharging efficiency";
  parameter Real etaBatChr=0.98
    "Electrical storage charging efficiency";
  parameter Modelica.Units.SI.Power PBatMax=EBatMax*0.25*0.001
    "Maximum charge/discharge power";
  parameter Modelica.Units.SI.Energy EBatMax(
    min=0,
    displayUnit="kW.h")=10000*3.6e+6
    "Maximum available charge for the battery";
  parameter Real SOC_start=0.5
    "Starting state of charge";
  parameter Real socMax = 0.9
    "Max state of charge";
  parameter Real socMin = 0.1
    "Min state of charge";
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
end ElectricalParameters;
