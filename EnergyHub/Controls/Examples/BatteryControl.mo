within EnergyHub.Controls.Examples;
model BatteryControl
  "Example model that tests and demonstrates the battery controller"
  extends Modelica.Icons.Example;
  EnergyHub.Controls.BatteryControl con(
    socMax=1,
    socMin=0,
    PBatMax=600,
    PDel=200)
    "Controller"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Ramp PGen(
    height=1000,
    duration=60,
    startTime=30)
    "Power generated on site"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp PDem(
    height=-1000,
    duration=60,
    offset=1000,
    startTime=30)
    "Power demand (at buildings)"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Pulse soc(period=60, startTime=30)
    "State of charge (decoupled from a real battery for testing purposes)"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(con.PLoa, PDem.y) annotation (Line(points={{-2,38},{-20,38},{-20,70},{
          -39,70}}, color={0,0,127}));
  connect(con.PGen, PGen.y)
    annotation (Line(points={{-2,30},{-39,30}}, color={0,0,127}));
  connect(soc.y, con.soc) annotation (Line(points={{-39,-10},{-10,-10},{-10,22},
          {-2,22}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=120,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Controls/Examples/BatteryControl.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Malihe Davari:<br/>
First implementation.
</li>
</ul>
</html>"));
end BatteryControl;
