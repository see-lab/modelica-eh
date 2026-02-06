within EnergyHub.Examples.Nonlinear;
model DirectLakeCoolingWithPVBESS
  "Electric heat pumps for heating with direct lake cooling and onsite PV and BESS"
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
    CCap=capExOnePV*nPV + capExBat*EBatMax + capExPum*mDis_flow_nominal);
  package Medium = Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT souDom(
    redeclare package Medium = Medium,
    T=TDomSup_nominal,
    nPorts=1)
    "Domestic water source"
    annotation (Placement(transformation(extent={{-112,-66},{-100,-54}})));
  Buildings.Fluid.Sources.Boundary_pT sinDom(
    redeclare package Medium = Medium,
    nPorts=1)
    "Domestic water sink"
    annotation (Placement(transformation(extent={{-112,-86},{-100,-74}})));
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
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.Sources.Boundary_pT souLak(
    redeclare package Medium = Medium,
    T=TLakSup_nominal,
    nPorts=1)
    "Lake source"
    annotation (Placement(transformation(extent={{-82,-6},{-70,6}})));
  Buildings.Fluid.Sources.Boundary_pT sinLak(
    redeclare package Medium = Medium,
    nPorts=1)
    "Lake sink"
    annotation (Placement(transformation(extent={{-82,-36},{-70,-24}})));
  Buildings.DHC.Networks.Pipes.PipeAutosize pipLak(
    redeclare package Medium = Medium,
    m_flow_nominal=mLak_flow_nominal,
    dh(fixed=true)=dhLak,
    dp_length_nominal=dp_length_nominal,
    length=lLak)
    "Supply pipe from the lake"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.FixedResistances.LosslessPipe pipRetLak(
    redeclare package Medium = Medium,
    m_flow_nominal=mLak_flow_nominal,
    show_T=true)
    "Return pipe from the lake"
    annotation (Placement(transformation(extent={{-40,-40},{-60,-20}})));
  EnergyHub.Sensors.ExergyFlowRate XLakSup_flow(redeclare package Medium =
        Medium, m_flow_nominal=mLak_flow_nominal)
    "Exergy flow supply from the lake"
    annotation (Placement(transformation(extent={{0,-8},{16,8}})));
  EnergyHub.Sensors.ExergyFlowRate XLakRet_flow(redeclare package Medium =
        Medium, m_flow_nominal=mLak_flow_nominal)
    "Exergy flow return to the lake"
    annotation (Placement(transformation(extent={{16,-38},{0,-22}})));
  Modelica.Blocks.Sources.RealExpression ssrThe_onsite(y=0)
    "Self-sufficiency ratio of the thermal system (exergy based) - lake on site"
    annotation (Placement(transformation(extent={{300,56},{320,76}})));
  Modelica.Blocks.Sources.RealExpression scrThe_onsite(
    y=1 - (XLakRet.y)/(XLakSup.y))
    "Self-coverage ratio of the thermal system (exergy based) - lake on site"
    annotation (Placement(transformation(extent={{300,2},{320,22}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv(
    pf=1,
    eta_DCAC=1,
    A=PV_surface*nPV,
    fAct=1,
    eta=PV_eff,
    til=0,
    azi=0,
    V_nominal=V_nominal)
    "Solar pannel with orientation"
    annotation (Placement(transformation(extent={{-36,70},{-56,90}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(
    etaCha=etaBatChr,
    etaDis=etaBatDis,
    SOC_start=SOC_start,
    EMax=EBatMax,
    V_nominal=V_nominal)
    "Electric battery"
    annotation (Placement(transformation(extent={{-30,8},{-50,28}})));
  Controls.BatteryControl conBat(
    socMax=socMax,
    socMin=socMin,
    PBatMax=PBatMax,
    PDel=1e-6)
    "Battery controller"
    annotation (Placement(transformation(extent={{-74,30},{-60,44}})));
  Modelica.Blocks.Math.Gain inv(k=-1)
    "Flip sign based on standard convention"
    annotation (Placement(transformation(extent={{-2,42},{-16,56}})));
  Modelica.Blocks.Continuous.Integrator XLakSup(y_start=1E-10)
    "Exergy supply from the lake"
    annotation (Placement(transformation(extent={{14,16},{24,26}})));
  Modelica.Blocks.Continuous.Integrator XLakRet(y_start=1E-10)
    "Exergy returned to the lake"
    annotation (Placement(transformation(extent={{16,-24},{26,-14}})));
  Modelica.Blocks.Sources.RealExpression QDotBuy(y=pipWat.m_flow*(pipWat.port_b.h_outflow
         - pipWatRet.port_b.h_outflow))
    "Heat flow rate coming into the system"
    annotation (Placement(transformation(extent={{136,-44},{156,-24}})));
  Modelica.Blocks.Continuous.Integrator QBuy(y_start=1E-10)
    "Thermal energy into the system boundary"
    annotation (Placement(transformation(extent={{174,-44},{194,-24}})));
  Modelica.Blocks.Continuous.Integrator QDemand_integration(y_start=1E-10)
    "converting thermal demand to energy"
    annotation (Placement(transformation(extent={{176,-74},{196,-54}})));
  Modelica.Blocks.Sources.RealExpression QDotDemBld(y=yHea.u + yDhw.u + yCoo.u)
    "Thermal demand (Heating, DHW) on the Building side (Heating HP condesor)"
    annotation (Placement(transformation(extent={{136,-74},{156,-54}})));
  Modelica.Blocks.Math.Division ratSsrThBld
    "Ratio of thermal energy imported from the external provider to thermal demands (heating and dhw)."
    annotation (Placement(transformation(extent={{214,-50},{234,-30}})));
  Modelica.Blocks.Sources.RealExpression QDotDemDEN(y=QDotBuy.y + pipLak.port_a.m_flow
        *(pipRetLak.port_b.h_outflow - pipLak.port_b.h_outflow))
                      "Thermal demand (Heating, DHW) on the DEN side."
    annotation (Placement(transformation(extent={{136,-98},{156,-78}})));
  Modelica.Blocks.Continuous.Integrator QDemand_integration1(y_start=1E-10)
    "converting thermal demand to energy"
    annotation (Placement(transformation(extent={{200,-98},{220,-78}})));
  Modelica.Blocks.Math.Division ratSsrThDen
    "Ratio of thermal energy imported from the external provider to thermal demands (heating and dhw)."
    annotation (Placement(transformation(extent={{236,-92},{256,-72}})));
  Modelica.Blocks.Sources.RealExpression ssr_T_eneDEN(y=1 - ratSsrThDen.y)
    "Self-sufficiency ratio of the thermal system (energy based) based on energy on DEN side"
    annotation (Placement(transformation(extent={{268,-98},{288,-78}})));


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
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(sinDom.ports[1], pipWatRet.port_b)
    annotation (Line(points={{-100,-80},{-80,-80}}, color={0,127,255}));
  connect(pipWat.port_b, dhw.port_a)
    annotation (Line(points={{-60,-60},{30,-60},{30,-50},{40,-50}},
                                                  color={0,127,255}));
  connect(pipWat.port_b, hea.port_a) annotation (Line(points={{-60,-60},{30,-60},
          {30,30},{40,30}}, color={0,127,255}));
  connect(pipWatRet.port_a, dhw.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,-50},{60,-50}}, color={0,127,255}));
  connect(pipWatRet.port_a, hea.port_b) annotation (Line(points={{-60,-80},{64,-80},
          {64,30},{60,30}}, color={0,127,255}));
  connect(sinLak.ports[1], pipRetLak.port_b)
    annotation (Line(points={{-70,-30},{-60,-30}},  color={0,127,255}));
  connect(souLak.ports[1], pipLak.port_a)
    annotation (Line(points={{-70,0},{-60,0}},    color={0,127,255}));
  connect(pipLak.port_b, XLakSup_flow.port_a)
    annotation (Line(points={{-40,0},{0,0}},     color={0,127,255}));
  connect(XLakSup_flow.port_b, coo.port_a) annotation (Line(points={{16,0},{20,0},
          {20,-10},{40,-10}},        color={0,127,255}));
  connect(pipRetLak.port_a, XLakRet_flow.port_b)
    annotation (Line(points={{-40,-30},{0,-30}},   color={0,127,255}));
  connect(coo.port_b, XLakRet_flow.port_a) annotation (Line(points={{60,-10},{68,
          -10},{68,-30},{16,-30}},                     color={0,127,255}));
  connect(pv.terminal, loa.terminal) annotation (Line(points={{-36,80},{-36,70},
          {-20,70}},          color={0,120,120}));
  connect(bat.terminal, loa.terminal) annotation (Line(points={{-30,18},{-30,70},
          {-20,70}},              color={0,120,120}));
  connect(conBat.PBat,bat. P) annotation (Line(points={{-59.3,37},{-40,37},{-40,
          28}},                color={0,0,127}));
  connect(bat.SOC,conBat. soc) annotation (Line(points={{-51,24},{-80,24},{-80,31.4},
          {-75.4,31.4}},                   color={0,0,127}));
  connect(pv.P,conBat. PGen) annotation (Line(points={{-57,87},{-88,87},{-88,37},
          {-75.4,37}},                 color={0,0,127}));
  connect(sumLoa.y,inv. u)
    annotation (Line(points={{9,70},{9,49},{-0.6,49}},     color={0,0,127}));
  connect(inv.y,conBat. PLoa) annotation (Line(points={{-16.7,49},{-80,49},{-80,
          42.6},{-75.4,42.6}},
                     color={0,0,127}));
  connect(pv.weaBus, weaBus) annotation (Line(
      points={{-46,89},{-46,102},{0,102},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(XLakRet_flow.X_flow, XLakRet.u)
    annotation (Line(points={{8,-21.2},{8,-19},{15,-19}}, color={0,0,127}));
  connect(XLakSup_flow.X_flow, XLakSup.u)
    annotation (Line(points={{8,8.8},{8,21},{13,21}}, color={0,0,127}));
  connect(QDotBuy.y, QBuy.u)
    annotation (Line(points={{157,-34},{172,-34}}, color={0,0,127}));
  connect(QDotDemBld.y, QDemand_integration.u)
    annotation (Line(points={{157,-64},{174,-64}}, color={0,0,127}));
  connect(QDotDemDEN.y, QDemand_integration1.u)
    annotation (Line(points={{157,-88},{198,-88}}, color={0,0,127}));
  connect(QBuy.y, ratSsrThDen.u1) annotation (Line(points={{195,-34},{198,-34},
          {198,-46},{206,-46},{206,-76},{234,-76}}, color={0,0,127}));
  connect(QDemand_integration1.y, ratSsrThDen.u2)
    annotation (Line(points={{221,-88},{234,-88}}, color={0,0,127}));
  connect(QBuy.y, ratSsrThBld.u1)
    annotation (Line(points={{195,-34},{212,-34}}, color={0,0,127}));
  connect(QDemand_integration.y, ratSsrThBld.u2) annotation (Line(points={{197,
          -64},{202,-64},{202,-46},{212,-46}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{360,120}})),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://MES/Resources/Scripts/Dymola/Examples/Nonlinear/DirectLakeCoolingWithPVBESS.mos"
        "Simulate and plot"),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{360,120}})),
    experiment(
      StartTime=18399600,
      StopTime=18482400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Nonlinear/DirectLakeCoolingWithPVBESS.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end DirectLakeCoolingWithPVBESS;
