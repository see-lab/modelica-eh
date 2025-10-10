within EnergyHub.Subsystems;
model LakeConnection "Model for lake interconnection"
  extends Buildings.DHC.Plants.BaseClasses.PartialPlant(
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false,
    final typ=Buildings.DHC.Types.DistrictSystemType.CombinedGeneration5);

  parameter Modelica.Units.SI.MassFlowRate mLak_flow_nominal
    "Lake water nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal
    "District water nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpLak_nominal
    "Lake side pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpDis_nominal
    "District side pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.Efficiency epsHex "Heat exchanger effectiveness";
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLakWat(
    final unit="K",
    displayUnit="degC") "Lake water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,240}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,220})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPum_flow(
    final unit="kg/s")
    "Pumps mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,160}),iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,140})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(final unit="W")
    "Variation of enthalpy flow rate across HX (leaving - entering)"
    annotation (
      Placement(transformation(extent={{300,60},{340,100}}),
        iconTransformation(extent={{300,80},{380,160}})));
  // COMPONENTS
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_nominal=mLak_flow_nominal,
    final m2_flow_nominal=mDis_flow_nominal,
    final dp1_nominal=dpLak_nominal,
    final dp2_nominal=dpDis_nominal,
    final eps=epsHex) "Heat exchanger (primary is lake water side)" annotation
    (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,14})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final dp_nominal=dpDis_nominal,
    final allowFlowReversal=allowFlowReversal)
    "District water pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-40})));
  Buildings.Fluid.Sources.Boundary_pT souLak(
    redeclare final package Medium = Medium,
    final use_T_in=true,
    final nPorts=2) "Source of lake water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,76})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumLak(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mLak_flow_nominal,
    final dp_nominal=dpLak_nominal,
    final allowFlowReversal=allowFlowReversal) "Lake\\ water pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTLakRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mLak_flow_nominal,
    tau=0) "Lake return temperature" annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-40,20})));
  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare package Medium1 = Medium,
    final m_flow_nominal=mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-16})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum sumPPum(nin=2) "Sum pump power"
    annotation (Placement(transformation(extent={{260,150},{280,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TLakRet(final unit="K")
  "Lake return temperature" annotation (Placement(transformation(
          extent={{380,300},{420,340}}), iconTransformation(extent={{300,160},{
            380,240}})));
equation
  connect(senTLakRet.port_b,souLak. ports[1])
    annotation (Line(points={{-46,20},{-60,20},{-60,75}}, color={0,127,255}));
  connect(souLak.ports[2],pumLak. port_a)
    annotation (Line(points={{-60,77},{-60,80},{30,80}},
                                                 color={0,127,255}));
  connect(souLak.T_in,TLakWat)  annotation (Line(points={{-82,80},{-100,80},{
          -100,240},{-400,240}},
                          color={0,0,127}));
  connect(mPum_flow,pumLak. m_flow_in)
    annotation (Line(points={{-400,160},{40,160},{40,92}},
                                                       color={0,0,127}));
  connect(pumLak.port_b, hex.port_a1) annotation (Line(points={{50,80},{60,80},
          {60,20},{10,20}},                color={0,127,255}));
  connect(hex.port_b1,senTLakRet. port_a) annotation (Line(points={{-10,20},{
          -34,20}},               color={0,127,255}));
  connect(mPum_flow, pumDis.m_flow_in)
    annotation (Line(points={{-400,160},{80,160},{80,-28}},
                                                         color={0,0,127}));
  connect(senDifEntFlo.dH_flow, dH_flow) annotation (Line(points={{3,-28},{3,
          -78},{258,-78},{258,80},{320,80}},
                                        color={0,0,127}));
  connect(senDifEntFlo.port_b2, hex.port_a2) annotation (Line(points={{-6,-6},{-6,
          0},{-20,0},{-20,8},{-10,8}},         color={0,127,255}));
  connect(hex.port_b2, senDifEntFlo.port_a1) annotation (Line(points={{10,8},{20,
          8},{20,0},{6,0},{6,-6}},         color={0,127,255}));
  connect(port_aSerAmb, senDifEntFlo.port_a2) annotation (Line(points={{-380,40},
          {-280,40},{-280,-40},{-6,-40},{-6,-26}}, color={0,127,255}));
  connect(senDifEntFlo.port_b1, pumDis.port_a)
    annotation (Line(points={{6,-26},{6,-40},{70,-40}}, color={0,127,255}));
  connect(pumDis.port_b, port_bSerAmb) annotation (Line(points={{90,-40},{280,
          -40},{280,40},{380,40}},
                              color={0,127,255}));
  connect(sumPPum.y, PPum) annotation (Line(points={{282,160},{294,160},{294,
          160},{400,160}}, color={0,0,127}));
  connect(pumLak.P, sumPPum.u[1]) annotation (Line(points={{51,89},{238,89},{
          238,159.5},{258,159.5}},
                               color={0,0,127}));
  connect(pumDis.P, sumPPum.u[2]) annotation (Line(points={{91,-31},{240,-31},{
          240,160.5},{258,160.5}},
                               color={0,0,127}));
  connect(senTLakRet.T, TLakRet) annotation (Line(points={{-40,26.6},{-40,320},{
          400,320}}, color={0,0,127}));
  annotation (
  DefaultComponentName="pla",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model of lake heat exchanger facility with mass flow rate and temperature as an input.
</p>
<p>
This model is a direct copy of 
<a href=\"modelica://Buildings.DHC.Plants.Heating.SewageHeatRecovery\">
Buildings.DHC.Plants.Heating.SewageHeatRecovery</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
Copied implementation of <a href=\"modelica://Buildings.DHC.Plants.Heating.SewageHeatRecovery\">
SewageHeatRecovery</a> for lake cooling purposes.
</li>
</ul>
</html>"));
end LakeConnection;
