within EnergyHub.Examples.Nonlinear;
model DirectLakeCoolingGridOnly
  "Electric heat pumps for heating with direct lake cooling"
  extends Modelica.Icons.Example;
  extends EnergyHub.Examples.Data.FluidParameters(
    mDis_flow_nominal=hea.mLoa_flow_nominal + dhw.mLoa_flow_nominal,
    mLak_flow_nominal=coo.mDis_flow_nominal);
  extends EnergyHub.Examples.BaseClasses.PartialNonlinearSystem(
    redeclare EnergyHub.Subsystems.HeatPump_y dhw(
      QLoa_flow_nominal=QDhw_flow_nominal,
      COP_nominal=COP_DHW,
      TCon_nominal=THeaWatSup_nominal,
      TEva_nominal=TDomSup_nominal - dT_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal + pipWat.dp_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium),
    redeclare EnergyHub.Subsystems.CoolingHeatExchanger coo(
      QLoa_flow_nominal=QCoo_flow_nominal,
      TDisSup_nominal=TLakSup_nominal,
      TBldSup_nominal=TCooWatSup_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal + pipLak.dp_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium),
    redeclare EnergyHub.Subsystems.HeatPump_y hea(
      QLoa_flow_nominal=QHea_flow_nominal,
      COP_nominal=COP_heating,
      TCon_nominal=THeaWatSup_nominal,
      TEva_nominal=TDomSup_nominal - dT_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal + pipWat.dp_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium));
  extends EnergyHub.Examples.BaseClasses.KeyPerformanceIndicators(
    PGriNet(y=gri.P.real),
    PLoa(y=-sumLoa.y),
    PGen(y=0),
    CCap=capExPum*mDis_flow_nominal);
  package Medium = Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT souDom(
    redeclare package Medium = Medium,
    T=TDomSup_nominal,
    nPorts=1)
    "Domestic water source"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinDom(
    redeclare package Medium = Medium,
    nPorts=1)
    "Domestic water sink"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Fluid.FixedResistances.LosslessPipe pipWatRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "Return water pipe (lossless)"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
  Buildings.DHC.Networks.Pipes.PipeAutosize pipWat(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    dh(fixed=true)=dhWat,
    dp_length_nominal=dp_length_nominal,
    length=lWat)
    "Supply pipe (domestic water)"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT souLak(
    redeclare package Medium = Medium,
    T=TLakSup_nominal,
    nPorts=1)
    "Lake source"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sources.Boundary_pT sinLak(
    redeclare package Medium = Medium,
    nPorts=1)
    "Lake sink"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.DHC.Networks.Pipes.PipeAutosize pipLak(
    redeclare package Medium = Medium,
    m_flow_nominal=mLak_flow_nominal,
    dh(fixed=true)=dhLak,
    dp_length_nominal=dp_length_nominal,
    length=lLak)
    "Supply pipe from the lake"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.FixedResistances.LosslessPipe pipRetLak(
    redeclare package Medium = Medium,
    m_flow_nominal=mLak_flow_nominal,
    show_T=true)
    "Return pipe from the lake"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
  EnergyHub.Sensors.ExergyFlowRate XLakSup_flow(redeclare package Medium =
        Medium, m_flow_nominal=mLak_flow_nominal)
    "Exergy flow supply from the lake"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  EnergyHub.Sensors.ExergyFlowRate XLakRet_flow(redeclare package Medium =
        Medium, m_flow_nominal=mLak_flow_nominal)
    "Exergy flow return to the lake"
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));
  Modelica.Blocks.Sources.RealExpression ssrThe_onsite(y=0)
    "Self-sufficiency ratio of the thermal system (exergy based) - lake on site"
    annotation (Placement(transformation(extent={{300,56},{320,76}})));
  Modelica.Blocks.Sources.RealExpression scrThe_onsite(
    y=1 - (XLakRet.y)/(XLakSup.y))
    "Self-coverage ratio of the thermal system (exergy based) - lake on site"
    annotation (Placement(transformation(extent={{300,2},{320,22}})));
  Modelica.Blocks.Continuous.Integrator XLakSup(y_start=1E-10)
    "Exergy supply from the lake"
    annotation (Placement(transformation(extent={{-10,30},{0,40}})));
  Modelica.Blocks.Continuous.Integrator XLakRet(y_start=1E-10)
    "Exergy returned to the lake"
    annotation (Placement(transformation(extent={{0,-10},{10,0}})));
  final parameter Modelica.Units.SI.Length dhWat(
    fixed=false,
    start=0.05,
    min=0.01)
    "Hydraulic diameter of the water pipe";
  final parameter Modelica.Units.SI.Length dhLak(
    fixed=false,
    start=0.05,
    min=0.01)
    "Hydraulic diameter of the lake pipe";
equation
  connect(souDom.ports[1], pipWat.port_a)
    annotation (Line(points={{-100,-50},{-80,-50}}, color={0,127,255}));
  connect(sinDom.ports[1], pipWatRet.port_b)
    annotation (Line(points={{-100,-80},{-80,-80}}, color={0,127,255}));
  connect(pipWat.port_b, dhw.port_a)
    annotation (Line(points={{-60,-50},{40,-50}}, color={0,127,255}));
  connect(pipWat.port_b, hea.port_a) annotation (Line(points={{-60,-50},{30,-50},
          {30,30},{40,30}}, color={0,127,255}));
  connect(pipWatRet.port_a, dhw.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,-50},{60,-50}}, color={0,127,255}));
  connect(pipWatRet.port_a, hea.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,30},{60,30}}, color={0,127,255}));
  connect(sinLak.ports[1], pipRetLak.port_b)
    annotation (Line(points={{-70,-20},{-60,-20}},  color={0,127,255}));
  connect(souLak.ports[1], pipLak.port_a)
    annotation (Line(points={{-70,10},{-60,10}},  color={0,127,255}));
  connect(pipLak.port_b, XLakSup_flow.port_a)
    annotation (Line(points={{-40,10},{-30,10}}, color={0,127,255}));
  connect(XLakSup_flow.port_b, coo.port_a) annotation (Line(points={{-10,10},{
          20,10},{20,-10},{40,-10}}, color={0,127,255}));
  connect(pipRetLak.port_a, XLakRet_flow.port_b)
    annotation (Line(points={{-40,-20},{-20,-20}}, color={0,127,255}));
  connect(coo.port_b, XLakRet_flow.port_a) annotation (Line(points={{60,-10},{
          68,-10},{68,-30},{20,-30},{20,-20},{0,-20}}, color={0,127,255}));
  connect(XLakRet_flow.X_flow, XLakRet.u)
    annotation (Line(points={{-10,-9},{-10,-5},{-1,-5}}, color={0,0,127}));
  connect(XLakSup_flow.X_flow, XLakSup.u)
    annotation (Line(points={{-20,21},{-20,35},{-11,35}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{360,120}})),
    experiment(
      StartTime=18399600,
      StopTime=18482400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Nonlinear/DirectLakeCoolingGridOnly.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end DirectLakeCoolingGridOnly;
