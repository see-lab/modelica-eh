within EnergyHub.Controls;
model BatteryControl "Controller for the electrical battery"
  extends Modelica.Blocks.Icons.Block;
  parameter Real socMax(min=0)=1
    "Maximum available charge";
  parameter Real socMin(min=0)=0.1
    "Minimum allowable charge";
  parameter Modelica.Units.SI.Power PBatMax(min=0)=1000
    "Maximum power charge/discarge rate";
  parameter Modelica.Units.SI.Power PDel= PBatMax*1e-3
    "Power delta (bandwidth) between power generated onsite and load to avoid rapid switching";
  Modelica.Blocks.Interfaces.RealInput soc(final unit="")
    "Battery state of charge"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PBat(final unit="W")
    "Battery power stored in battery (if positive) or discharging (if negative)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput PGen(final unit="W")
    "Power generated on site"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput PLoa(final unit="W")
    "Load power (i.e., demand)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
equation
  if PGen > PLoa + PDel and soc < socMax then
    PBat= min((PGen-PLoa), PBatMax);  // Charging
  elseif PGen < PLoa - PDel and soc > socMin then
    PBat=max((PGen-PLoa), -PBatMax); // Disharging
  else
    PBat=0; // No change
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a basic battery controller with the following logic:</p>
</html>", revisions="<html>
<ul>
<li>
October 10, 2025 by Malihe Davari:<br/>
First implementation.
</li>
</ul>
</html>"));
end BatteryControl;
