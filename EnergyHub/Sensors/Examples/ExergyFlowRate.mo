within EnergyHub.Sensors.Examples;
model ExergyFlowRate
  "Example model to test and demonstrate the exergy flow sensor"
  extends Modelica.Icons.Example;
  package MediumWat = Buildings.Media.Water "Water medium model";
  package MediumAir = Buildings.Media.Air "Air medium model";
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Flow boundary condition"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_ph sinWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Flow boundary condition"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,30})));
  Modelica.Blocks.Sources.Ramp mFlo(
    height=1,
    offset=0,
    duration=60,
    startTime=30)
    "Mass flow rate signal"
    annotation (Placement(transformation(extent={{-80,28},{-60,48}})));
  EnergyHub.Sensors.ExergyFlowRate XFloWat(redeclare package Medium = MediumWat,
      m_flow_nominal=1) "Sensor in the water stream"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Flow boundary condition"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  EnergyHub.Sensors.ExergyFlowRate XFloAir(redeclare package Medium = MediumAir,
      m_flow_nominal=1) "Sensor in the air stream"
    annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
  Buildings.Fluid.Sources.Boundary_ph sinAir(
    redeclare package Medium = MediumAir,
    nPorts=1) "Flow boundary condition" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-20})));
  Modelica.Blocks.Sources.Ramp TIn(
    height=-20,
    offset=273.15 + 40,
    duration=30,
    startTime=90) "Temperature signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(mFlo.y, souWat.m_flow_in)
    annotation (Line(points={{-59,38},{-42,38}},
                                               color={0,0,127}));
  connect(souWat.ports[1], XFloWat.port_a)
    annotation (Line(points={{-20,30},{10,30}}, color={0,127,255}));
  connect(XFloWat.port_b, sinWat.ports[1])
    annotation (Line(points={{30,30},{60,30}}, color={0,127,255}));
  connect(mFlo.y, souAir.m_flow_in) annotation (Line(points={{-59,38},{-50,38},{
          -50,-12},{-42,-12}},
                           color={0,0,127}));
  connect(souAir.ports[1], XFloAir.port_a)
    annotation (Line(points={{-20,-20},{12,-20}}, color={0,127,255}));
  connect(XFloAir.port_b, sinAir.ports[1])
    annotation (Line(points={{32,-20},{60,-20}}, color={0,127,255}));
  connect(TIn.y, souWat.T_in) annotation (Line(points={{-59,-40},{-52,-40},{-52,
          34},{-42,34}},
                       color={0,0,127}));
  connect(TIn.y, souAir.T_in) annotation (Line(points={{-59,-40},{-52,-40},{-52,
          -16},{-42,-16}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=160,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Sensors/Examples/ExergyFlowRate.mos"
        "Simulate and plot"));
end ExergyFlowRate;
