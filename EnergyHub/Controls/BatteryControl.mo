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
<ul>
<li>If the onsite power generation exceeds the power demand and the battery has available capacity (SOC is less than the maximum value), the surplus power is stored in the battery. </li>
<li>However, if the battery SOC is full or the surplus power exceeds the battery&rsquo;s maximum charging rate, the excess power is injected into the main grid. </li>
<li>When onsite power generation is lower than the demand, the battery serves as the primary power source (while SOC is less than the minimum value); if the demand still exceeds the available power, additional electricity is purchased from the grid. </li>
<li>The maximal battery charging/discharging rate is limited by user-specified parameter, with excess power being sold to/purchased from the grid, when present. </li>
<li>Lastly, we implement a small deadband of 10^-6yW between the on-site power generation and the load to avoid rapid switching of the battery&apos;s charging/discharging state. </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
October 10, 2025 by Malihe Davari:<br/>
First implementation.
</li>
</ul>
</html>"));
end BatteryControl;
