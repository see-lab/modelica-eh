within EnergyHub.Subsystems.BaseClasses;
partial model PartialThermalSubsystem
  "Partial model for subsystem interconnection for thermal (heating, cooling, dhw) subsystems"
  replaceable package MediumLoa=Modelica.Media.Interfaces.PartialMedium
    "Medium model on building (load) side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumDis=Modelica.Media.Interfaces.PartialMedium
    "Medium model on district (service) side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  parameter Boolean heaMod = true "True for a heating mode, false for cooling";
  final parameter Real heaModSig = if heaMod then -1 else 1;
  parameter Modelica.Units.SI.HeatFlowRate QLoa_flow_nominal(min=0)
    "Nominal heat flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal
    "Load side mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal
    "District side mass flow rate";
  parameter Boolean allowFlowReversalLoa=false
    "Set to true to allow flow reversal on load side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalDis=false
    "Set to true to allow flow reversal on district side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Units.SI.Pressure dpLoa_nominal(displayUnit="Pa")
    "Pressure difference over load"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpDis_nominal(displayUnit="Pa")
    "Pressure difference over district"
    annotation (Dialog(group="Nominal condition"));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumDis,
    m_flow(min=if allowFlowReversalDis then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "Fluid port for district service"
    annotation (Placement(
      transformation(extent={{110,-20},{130,0}}),
      iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumDis,
    m_flow(max=if allowFlowReversalDis then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "Fluid port for the service district water return)"
    annotation (Placement(
       transformation(extent={{-130,-20},{-110,0}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W") "Power"
    annotation (Placement(transformation(extent={{120,100},{160,140}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yLoa(final unit="W")
    "Relative load" annotation (Placement(transformation(
          extent={{-160,20},{-120,60}}), iconTransformation(extent={{-140,20},{
            -100,60}})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumLoa(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = MediumLoa,
    m_flow_nominal=mLoa_flow_nominal,
    riseTime=10,
    dp_nominal=dpLoa_nominal) "Pump for load side"     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,80})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium = MediumLoa,
    m_flow_nominal=mLoa_flow_nominal,
    dp_nominal=0,
    Q_flow_nominal=QLoa_flow_nominal) "Heating or cooling load"
    annotation (Placement(transformation(extent={{-10,70},{-30,90}})));
  Modelica.Blocks.Math.Gain mod(k=heaModSig) "Heating or cooling mode sign"
    annotation (Placement(transformation(extent={{-48,90},{-28,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium = MediumDis,
    final allowFlowReversal=allowFlowReversalDis,
    final m_flow_nominal=mDis_flow_nominal,
    tau=0) "District supply temperature sensor (service side)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={70,-10})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium = MediumDis,
    final allowFlowReversal=allowFlowReversalDis,
    final m_flow_nominal=mDis_flow_nominal,
    tau=0) "District return temperature sensor (service side)"
     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-60,-10})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna(start=false)
    "Enable signal"
    annotation (
      Placement(transformation(extent={{-160,100},{-120,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal flo "Flow enabled"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floLoa
    "Zero flow rate if not enabled (load side)"
    annotation (Placement(transformation(extent={{-70,36},{-50,56}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = MediumLoa,
    nPorts=1)
    "Boundary reference pressure" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,80})));
  Modelica.Blocks.Math.Gain mFloSet(k=mLoa_flow_nominal)
    "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-28,36},{-8,56}})));
  Modelica.Blocks.Math.Sum sumPow
    "Sum of all powers (heating, pumping)"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpLoa_default=
    MediumLoa.specificHeatCapacityCp(MediumLoa.setState_pTX(
      p=MediumLoa.p_default,
      T=MediumLoa.T_default,
      X=MediumLoa.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  connect(yLoa,mod. u) annotation (Line(points={{-140,40},{-86,40},{-86,100},{-50,
          100}},      color={0,0,127}));
  connect(mod.y, loa.u) annotation (Line(points={{-27,100},{0,100},{0,86},{-8,86}},
                    color={0,0,127}));
  connect(pumLoa.port_b, loa.port_a)
    annotation (Line(points={{10,80},{-10,80}}, color={0,127,255}));
  connect(uEna, flo.u)
    annotation (Line(points={{-140,120},{-102,120}}, color={255,0,255}));
  connect(yLoa,floLoa. u2)
    annotation (Line(points={{-140,40},{-72,40}}, color={0,0,127}));
  connect(flo.y, floLoa.u1) annotation (Line(points={{-78,120},{-76,120},{-76,
          52},{-72,52}}, color={0,0,127}));
  connect(bou.ports[1],pumLoa. port_a)
    annotation (Line(points={{60,80},{30,80}}, color={0,127,255}));
  connect(floLoa.y, mFloSet.u)
    annotation (Line(points={{-48,46},{-30,46}}, color={0,0,127}));
  connect(mFloSet.y,pumLoa. m_flow_in)
    annotation (Line(points={{-7,46},{20,46},{20,68}}, color={0,0,127}));
  connect(sumPow.y, P) annotation (Line(points={{101,50},{114,50},{114,120},{
          140,120}}, color={0,0,127}));
  connect(pumLoa.P, sumPow.u[1])
    annotation (Line(points={{9,71},{0,71},{0,50},{78,50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-152,-100},{148,-140}},
          textColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-140},{120,140}})));
end PartialThermalSubsystem;
