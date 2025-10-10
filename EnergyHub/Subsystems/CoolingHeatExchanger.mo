within EnergyHub.Subsystems;
model CoolingHeatExchanger
  "Heat exchanger subsystem for direct cooling"
  extends EnergyHub.Subsystems.BaseClasses.PartialThermalSubsystem(
    final heaMod=false,
    final mLoa_flow_nominal=QLoa_flow_nominal/cpLoa_default/dT_nominal,
    final mDis_flow_nominal=mLoa_flow_nominal,
    sumPow(nin=2),
    pumLoa(show_T=true),
    loa(show_T=true));
  parameter Modelica.Units.SI.Temperature TDisSup_nominal
    "Nominal district supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TDisRet_nominal=
    TDisSup_nominal+dT_nominal
    "Nominal district supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TBldSup_nominal
    "Nominal buildng supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TBldRet_nominal=
    TBldSup_nominal+dT_nominal
    "Nominal buildng return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0)=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pumDis(
    redeclare final package Medium = MediumDis,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversalDis,
    addPowerToMedium=false,
    show_T=true,
    m_flow_nominal=mDis_flow_nominal,
    dp_nominal=dpDis_nominal + 6000)
    "Pump for district (service) side"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,-10})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPI(
    k=0.15,
    Ti=120,
    xi_start=0,
    reverseActing=false)
    "Controller to ensure dT_nominal over heat pump connection"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Constant one(k=1)
    "Constant one for relative temperature setpoint (u_m scaled by setpoint via gain)"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexChi(
    redeclare final package Medium1 = MediumLoa,
    redeclare final package Medium2 = MediumDis,
    final m1_flow_nominal=mLoa_flow_nominal,
    final m2_flow_nominal=mDis_flow_nominal,
    show_T=true,
    final dp1_nominal=dpLoa_nominal/2,
    final dp2_nominal=dpDis_nominal/2,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=QLoa_flow_nominal,
    final T_a1_nominal=TBldRet_nominal,
    final T_a2_nominal=TDisSup_nominal,
    final allowFlowReversal1=allowFlowReversalLoa,
    final allowFlowReversal2=allowFlowReversalDis)
    "Chilled water HX"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTLoaSup(
    redeclare final package Medium = MediumLoa,
    final allowFlowReversal=allowFlowReversalDis,
    final m_flow_nominal=mLoa_flow_nominal,
    tau=0)
    "Load supply temperature sensor" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={40,16})));
  Modelica.Blocks.Math.Gain relTMea(k=1/TBldSup_nominal)
    "Relative measured temperature compared to setpoint"
    annotation (Placement(transformation(extent={{28,-100},{8,-80}})));
equation
  connect(uEna, conPI.trigger) annotation (Line(points={{-140,120},{-110,120},{-110,
          -80},{-6,-80},{-6,-72}},        color={255,0,255}));
  connect(senTDisSup.port_a, port_a)
    annotation (Line(points={{80,-10},{120,-10}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_b)
    annotation (Line(points={{-70,-10},{-120,-10}}, color={0,127,255}));
  connect(senTDisSup.port_b, pumDis.port_a)
    annotation (Line(points={{60,-10},{30,-10}}, color={0,127,255}));
  connect(senTLoaSup.port_b, pumLoa.port_a) annotation (Line(points={{50,16},{54,
          16},{54,80},{30,80}}, color={0,127,255}));
  connect(conPI.y, pumDis.y)
    annotation (Line(points={{12,-60},{20,-60},{20,-22}}, color={0,0,127}));
  connect(pumDis.P, sumPow.u[2]) annotation (Line(points={{9,-19},{0,-19},{0,50},
          {78,50}}, color={0,0,127}));
  connect(pumDis.port_b, hexChi.port_a2) annotation (Line(points={{10,-10},{-4,-10},
          {-4,4},{-10,4}}, color={0,127,255}));
  connect(hexChi.port_b2, senTDisRet.port_a) annotation (Line(points={{-30,4},{-44,
          4},{-44,-10},{-50,-10}}, color={0,127,255}));
  connect(loa.port_b, hexChi.port_a1) annotation (Line(points={{-30,80},{-44,80},
          {-44,16},{-30,16}}, color={0,127,255}));
  connect(hexChi.port_b1, senTLoaSup.port_a)
    annotation (Line(points={{-10,16},{30,16}}, color={0,127,255}));
  connect(one.y, conPI.u_s)
    annotation (Line(points={{-29,-60},{-12,-60}}, color={0,0,127}));
  connect(relTMea.y, conPI.u_m)
    annotation (Line(points={{7,-90},{0,-90},{0,-72}}, color={0,0,127}));
  connect(senTLoaSup.T, relTMea.u)
    annotation (Line(points={{40,5},{40,-90},{30,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,70},{60,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,21},{4,-21}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          origin={-81,2},
          rotation=90),
        Rectangle(
          extent={{100,4},{60,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-152,-100},{148,-140}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-60,2},{-40,2},{-30,52},{-12,-40},{8,52},{30,-40},{40,0},{60,
              0}},
          color={0,0,0},
          thickness=0.5)}),
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
end CoolingHeatExchanger;
