within EnergyHub.Subsystems;
model Chiller_y
  "Chiller (aka heat pump  - cooling mode) with ideal control that takes load 
  input signal for the load (condenser side) heat flow rate"
  extends EnergyHub.Subsystems.BaseClasses.PartialThermalSubsystem(
    final heaMod=false,
    final mLoa_flow_nominal=chi.m2_flow_nominal,
    final mDis_flow_nominal=chi.m1_flow_nominal,
    sumPow(nin=3),
    loa(show_T=true),
    pumLoa(show_T=true));
  parameter Real COP_nominal(unit="1")
    "Heat pump COP"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Condenser outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Evaporator outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0)=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.Chillers.Carnot_TEva chi(
    redeclare final package Medium1 = MediumLoa,
    redeclare final package Medium2 = MediumDis,
    final allowFlowReversal1=allowFlowReversalLoa,
    final allowFlowReversal2=allowFlowReversalDis,
    show_T=true,
    QEva_flow_nominal=-QLoa_flow_nominal,
    dTEva_nominal=-dT_nominal,
    dTCon_nominal=dT_nominal,
    use_eta_Carnot_nominal=false,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    final dp1_nominal=dpLoa_nominal,
    final dp2_nominal=dpDis_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chiller"
    annotation (Placement(transformation(extent={{-20,14},{-40,-6}})));
  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pumDis(
    redeclare final package Medium = MediumDis,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversalDis,
    addPowerToMedium=false,
    use_inputFilter=false,
    show_T=true,
    m_flow_nominal=mDis_flow_nominal,
    dp_nominal=dpDis_nominal + 6000)
    "Pump for district (service) side"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,-10})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT_supRet
    "Temperature difference over heat pump connection"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTSet(
    k=-heaModSig*dT_nominal)
    "Set point for temperature difference over heat pump"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPI(
    k=0.1,
    Ti=120,
    xi_start=0.2,
    reverseActing=true)
    "Controller to ensure dT_nominal over heat pump connection"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = MediumDis)
    "Mass flow rate drawn from ETS"
    annotation (Placement(transformation(extent={{110,-20},{90,0}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valDis(
    redeclare package Medium = MediumDis,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mDis_flow_nominal,
    dpValve_nominal=6000)
    "Valve at district side"
    annotation (Placement(transformation(extent={{50,-20},{30,0}})));
  Buildings.DHC.ETS.BaseClasses.Junction jun(
    redeclare package Medium = MediumDis,
    m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mDis_flow_nominal})
    "Fluid junction"
    annotation (Placement(transformation(extent={{-80,-20},{-100,0}})));
  Modelica.Blocks.Sources.Constant TSet(k=TEva_nominal)
    "Evaporator water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
equation
  connect(senTDisSup.T,dT_supRet. u1) annotation (Line(points={{70,-21},{70,-50},
          {-30,-50},{-30,-114},{-22,-114}},
                                       color={0,0,127}));
  connect(conPI.u_s,dTSet. y)
    annotation (Line(points={{18,-80},{2,-80}},color={0,0,127}));
  connect(dT_supRet.y,conPI. u_m)
    annotation (Line(points={{2,-120},{30,-120},{30,-92}},   color={0,0,127}));
  connect(conPI.y, valDis.y) annotation (Line(points={{42,-80},{52,-80},{52,6},
          {40,6},{40,2}}, color={0,0,127}));
  connect(senTDisRet.T,dT_supRet. u2) annotation (Line(points={{-60,-21},{-60,
          -126},{-22,-126}},
                          color={0,0,127}));
  connect(senTDisSup.port_a,senMasFlo. port_b)
    annotation (Line(points={{80,-10},{90,-10}},   color={0,127,255}));
  connect(valDis.port_1, senTDisSup.port_b)
    annotation (Line(points={{50,-10},{60,-10}}, color={0,127,255}));
  connect(jun.port_3, valDis.port_3) annotation (Line(points={{-90,-20},{-90,-40},
          {40,-40},{40,-20}}, color={0,127,255}));
  connect(valDis.port_2, pumDis.port_a)
    annotation (Line(points={{30,-10},{20,-10}}, color={0,127,255}));
  connect(jun.port_1,senTDisRet.port_b)
    annotation (Line(points={{-80,-10},{-70,-10}}, color={0,127,255}));
  connect(jun.port_2, port_b)
    annotation (Line(points={{-100,-10},{-120,-10}}, color={0,127,255}));
  connect(senMasFlo.port_a, port_a)
    annotation (Line(points={{110,-10},{120,-10}},
                                               color={0,127,255}));
  connect(flo.y, pumDis.y) annotation (Line(points={{-78,120},{40,120},{40,8},{
          10,8},{10,2}}, color={0,0,127}));
  connect(TSet.y, chi.TSet) annotation (Line(points={{-79,-70},{-32,-70},{-32,-48},
          {-10,-48},{-10,-5},{-18,-5}},
                             color={0,0,127}));
  connect(pumDis.port_b, chi.port_a1) annotation (Line(points={{0,-10},{-6,-10},
          {-6,-2},{-20,-2}}, color={0,127,255}));
  connect(chi.port_b1, senTDisRet.port_a) annotation (Line(points={{-40,-2},{-46,
          -2},{-46,-10},{-50,-10}}, color={0,127,255}));
  connect(loa.port_b, chi.port_a2) annotation (Line(points={{-30,80},{-46,80},{-46,
          10},{-40,10}}, color={0,127,255}));
  connect(chi.port_b2, pumLoa.port_a) annotation (Line(points={{-20,10},{38,10},
          {38,80},{30,80}}, color={0,127,255}));
  connect(uEna, conPI.trigger) annotation (Line(points={{-140,120},{-110,120},{
          -110,-100},{24,-100},{24,-92}}, color={255,0,255}));
  connect(pumDis.P, sumPow.u[2])
    annotation (Line(points={{-1,-1},{0,-1},{0,50},{78,50}}, color={0,0,127}));
  connect(pumDis.P, sumPow.u[3])
    annotation (Line(points={{-1,-1},{0,-1},{0,50},{78,50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-152,-100},{148,-140}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-56,70},{64,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,34},{-8,14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,2},{-20,14},{-4,14},{-12,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,2},{-20,-10},{-4,-10},{-12,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-10},{-8,-38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,36},{30,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{24,12},{14,-8},{36,-8},{24,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{12,12},{38,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{102,4},{70,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,4},{78,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,-38},{40,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,20},{4,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          origin={-48,-42},
          rotation=90),
        Rectangle(
          extent={{-70,4},{-62,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,19},{4,-19}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          origin={-81,0},
          rotation=90),
        Rectangle(
          extent={{-32,50},{46,34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-34},{46,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-140},{120,140}})),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Chiller_y;
