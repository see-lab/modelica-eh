within EnergyHub.Subsystems.Examples;
model HeatPump_y
  "Example model that tests and demonstrates the heat pump subsystem"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter String filNam= "modelica://MES/Resources/Data/v012/Loads.mos"
    "Library path of the file with input data as time series";
  parameter Real COP_nominal = 5;
  parameter Modelica.Units.SI.Temperature TDisWatMin=6 + 273.15
    "District water minimum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDisWatMax=17 + 273.15
    "District water maximum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 4
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=38 + 273.15
    "Heating water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa")=6000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation (Dialog(group="ETS model parameters"));
  final parameter Modelica.Units.SI.HeatFlowRate QLoa_nominal(
    min=Modelica.Constants.eps)=1000;
  EnergyHub.Subsystems.HeatPump_y heaPum(
    redeclare package MediumLoa = Medium,
    redeclare package MediumDis = Medium,
    QLoa_flow_nominal=QLoa_nominal,
    dpLoa_nominal=dp_nominal,
    dpDis_nominal=dp_nominal,
    COP_nominal=COP_nominal,
    TCon_nominal=THeaWatSup_nominal,
    TEva_nominal=sou.T - dT_nominal,
    dT_nominal=dT_nominal)
    "Heat pump"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=280.15,
    nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=heaPum.mDis_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Sine sin1(f=1/(86400/2))
    "Load signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=1, uMin=0)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaHea(t=1e-4)
    "Threshold comparison to enable heating"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain QFloExp(k=QLoa_nominal)
    "Heat flow rate expected"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(heaPum.port_b, senTem.port_a) annotation (Line(points={{60,-10},{40,
          -10},{40,-40},{20,-40}},
                             color={0,127,255}));
  connect(senTem.port_b, sin.ports[1])
    annotation (Line(points={{0,-40},{-20,-40}},   color={0,127,255}));
  connect(sin1.y, limiter.u)
    annotation (Line(points={{-59,40},{-42,40}}, color={0,0,127}));
  connect(enaHea.y, heaPum.uEna) annotation (Line(points={{22,0},{58,0},{58,-1}},
                               color={255,0,255}));
  connect(limiter.y,enaHea. u) annotation (Line(points={{-19,40},{-10,40},{-10,
          0},{-2,0}},                  color={0,0,127}));
  connect(limiter.y, heaPum.yLoa) annotation (Line(points={{-19,40},{30,40},{30,
          -6},{58,-6}}, color={0,0,127}));
  connect(sou.ports[1], heaPum.port_a) annotation (Line(points={{-20,-70},{90,
          -70},{90,-10},{80,-10}}, color={0,127,255}));
  connect(limiter.y, QFloExp.u) annotation (Line(points={{-19,40},{-10,40},{-10,
          70},{-2,70}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Subsystems/Examples/HeatPump_y.mos"
        "Simulate and plot"));
end HeatPump_y;
