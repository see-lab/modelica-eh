within EnergyHub.Sensors;
model ExergyFlowRate "Ideal exergy flow rate sensor"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation (Dialog(group="Nominal condition"));
  extends Modelica.Icons.RoundSensor;
  parameter Modelica.Units.SI.Temperature T_0=293.15
  "Dead state temperature";
  parameter Modelica.Units.SI.Pressure p_0=100000
  "Dead state pressure (atmospheric pressure by default)";
  final parameter Modelica.Units.SI.SpecificEnthalpy h_0=
    Medium.specificEnthalpy(
      Medium.setState_pTX(
        p=p_0,
        T=T_0,
        X=Medium.X_default))
  "Specific enthalphy at the dead state (T_0,p_0)";
  final parameter Modelica.Units.SI.SpecificEntropy s_0=
    Medium.specificEntropy(
      Medium.setState_pTX(
        p=p_0,
        T=T_0,
        X=Medium.X_default))
  "Specific entropy at the dead state (T_0,p_0)";
  Modelica.Blocks.Interfaces.RealOutput X_flow(final unit="W")
    "Exergy flow rate, positive if from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  protected
  Buildings.Fluid.Sensors.EnthalpyFlowRate H_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sensors.EntropyFlowRate S_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    "Entropy flow rate"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Constant T_0_internal(k=T_0) "Dead state temperature"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Math.Add dH(k1=-1) "Enthalpy difference from dead state"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Math.Add dS(k1=-1) "Entropy difference from dead state"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Math.Add X_flow_internal(k1=-1) "Exergy flow rate"
    annotation (Placement(transformation(extent={{20,60},{0,80}})));
  Modelica.Blocks.Math.Product TdS "Entropy component of exergy flow balance"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Modelica.Blocks.Sources.RealExpression H_0(y=h_0*port_a.m_flow)
    "Dead state enthalphy"
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));
  Modelica.Blocks.Sources.RealExpression S_0(y=s_0*port_a.m_flow)
    "Dead state entropy"
    annotation (Placement(transformation(extent={{0,26},{20,46}})));
equation
  connect(H_flow.port_b, S_flow.port_a)
    annotation (Line(points={{-40,-30},{20,-30}}, color={0,127,255}));
  connect(port_a, H_flow.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -30},{-60,-30}}, color={0,127,255}));
  connect(S_flow.port_b, port_b) annotation (Line(points={{40,-30},{72,-30},{72,
          0},{100,0}}, color={0,127,255}));
  connect(H_flow.H_flow, dH.u2)
    annotation (Line(points={{-50,-19},{-50,24},{-42,24}}, color={0,0,127}));
  connect(S_flow.S_flow, dS.u2)
    annotation (Line(points={{30,-19},{30,24},{38,24}}, color={0,0,127}));
  connect(dS.y, TdS.u2) annotation (Line(points={{61,30},{64,30},{64,44},{68,44}},
        color={0,0,127}));
  connect(T_0_internal.y, TdS.u1) annotation (Line(points={{61,70},{64,70},{64,56},
          {68,56}}, color={0,0,127}));
  connect(dH.y, X_flow_internal.u2) annotation (Line(points={{-19,30},{-10,30},{
          -10,56},{32,56},{32,64},{22,64}}, color={0,0,127}));
  connect(TdS.y, X_flow_internal.u1) annotation (Line(points={{91,50},{96,50},{96,
          90},{30,90},{30,76},{22,76}}, color={0,0,127}));
  connect(X_flow_internal.y, X_flow) annotation (Line(points={{-1,70},{-10,70},{
          -10,94},{0,94},{0,110}}, color={0,0,127}));
  connect(H_0.y, dH.u1)
    annotation (Line(points={{-59,36},{-42,36}}, color={0,0,127}));
  connect(S_0.y, dS.u1)
    annotation (Line(points={{21,36},{38,36}}, color={0,0,127}));
annotation (defaultComponentName="senExeFlo",
  Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          textColor={0,0,0},
          textString="X_flow"),
        Text(
          extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(X_flow, leftJustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the exergy flow rate of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
The general design is based on 
<a href=\"modelica://Buildings.Fluid.Sensors.EnthalpyFlowRate\">
Buildings.Fluid.Sensors.EnthalpyFlowRate</a>.
See <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation of this modeling package.
</p>
<p>
On a mass basis, The measured enthalpy and entropy <i>H</i> and <i>S</i> are used to
compute the exergy flow rate
<i>X&#775; = m&#775; ( H-H<sub>0</sub> - 
T<sub>0</sub>S-S<sub>0</sub>) )</i>.

</p>
</html>",
revisions="<html>
<ul>
<li>
July 3, 2025 by Kathryn Hinkelman:<br/>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end ExergyFlowRate;
