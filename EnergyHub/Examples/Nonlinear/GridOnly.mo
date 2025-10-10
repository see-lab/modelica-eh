within EnergyHub.Examples.Nonlinear;
model GridOnly
  "Grid only model with nonlinear thermofluid system (heat pumps)"
  extends Modelica.Icons.Example;
  extends EnergyHub.Examples.Data.FluidParameters(
    mDis_flow_nominal=hea.mLoa_flow_nominal+coo.mLoa_flow_nominal+
      dhw.mLoa_flow_nominal,
    mLak_flow_nominal=0);
  extends EnergyHub.Examples.BaseClasses.PartialNonlinearSystem(
    redeclare EnergyHub.Subsystems.HeatPump_y dhw(
      QLoa_flow_nominal=QDhw_flow_nominal,
      COP_nominal=COP_DHW,
      TCon_nominal=THeaWatSup_nominal,
      TEva_nominal=TDomSup_nominal - dT_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium),
    redeclare EnergyHub.Subsystems.Chiller_y coo(
      QLoa_flow_nominal=QCoo_flow_nominal,
      COP_nominal=COP_cooling,
      TCon_nominal=TDomSup_nominal + dT_nominal,
      TEva_nominal=TCooWatSup_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium),
    redeclare EnergyHub.Subsystems.HeatPump_y hea(
      QLoa_flow_nominal=QHea_flow_nominal,
      COP_nominal=COP_heating,
      TCon_nominal=THeaWatSup_nominal,
      TEva_nominal=TDomSup_nominal - dT_nominal,
      dT_nominal=dT_nominal,
      dpLoa_nominal=dpLoa_nominal,
      dpDis_nominal=dpDis_nominal,
      redeclare package MediumLoa = Medium,
      redeclare package MediumDis = Medium));
  extends EnergyHub.Examples.BaseClasses.KeyPerformanceIndicators(
    PGriNet(y=gri.P.real),
    PLoa(y=-sumLoa.y),
    PGen(y=0),
    CCap=0);
  package Medium = Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=TDomSup_nominal,
    nPorts=1)
    "Water source"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1)
    "Water sink"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Fluid.FixedResistances.LosslessPipe pipRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "Return pipe"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
  Buildings.Fluid.FixedResistances.LosslessPipe pipSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "Supply pipe"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(sou.ports[1], pipSup.port_a)
    annotation (Line(points={{-100,-50},{-80,-50}}, color={0,127,255}));
  connect(sin.ports[1], pipRet.port_b)
    annotation (Line(points={{-100,-80},{-80,-80}}, color={0,127,255}));
  connect(pipSup.port_b, dhw.port_a)
    annotation (Line(points={{-60,-50},{40,-50}}, color={0,127,255}));
  connect(pipSup.port_b, coo.port_a) annotation (Line(points={{-60,-50},{30,-50},
          {30,-10},{40,-10}}, color={0,127,255}));
  connect(pipSup.port_b, hea.port_a) annotation (Line(points={{-60,-50},{30,-50},
          {30,30},{40,30}}, color={0,127,255}));
  connect(pipRet.port_a, dhw.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,-50},{60,-50}}, color={0,127,255}));
  connect(pipRet.port_a, coo.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,-10},{60,-10}}, color={0,127,255}));
  connect(pipRet.port_a, hea.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,30},{60,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{360,120}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Nonlinear/GridOnly.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end GridOnly;
