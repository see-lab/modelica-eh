within EnergyHub.Examples.BaseClasses;
partial model PartialGrid
  "Base class with electrical subsystem for studying a variety of MES"
  extends EnergyHub.Examples.Data.ElectricalParameters;
  extends EnergyHub.Examples.Data.FilePaths;
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(f=60, V=V_nominal)
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Inductive loa(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    linearized=false,
    use_pf_in=false,
    pf=pfLoa)
    "Total electric load"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam=Modelica.Utilities.Files.loadResource(weaFilNam))
    "Weather data model"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Modelica.Blocks.Math.Sum sumLoa(nin=4, k=-ones(4))
    "Sum of the total electric load"
    annotation (Placement(transformation(extent={{30,60},{10,80}})));
  Modelica.Blocks.Sources.CombiTimeTable loaInp(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    columns=1:5,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale(displayUnit="s") = 3600)
    "Total heat flow rate of heating load"
    annotation (Placement(transformation(extent={{120,60},{100,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
  "Weather data bus"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Math.Gain PEle(k=1)
    "Electric power (convert kW to W)"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
equation
  connect(gri.terminal, loa.terminal)
    annotation (Line(points={{-110,80},{-110,70},{-20,70}},color={0,120,120}));
  connect(sumLoa.y, loa.Pow)
    annotation (Line(points={{9,70},{0,70}},   color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{10,120},{16,120},{16,100},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(loaInp.y[5],PEle. u)
    annotation (Line(points={{99,70},{82,70}}, color={0,0,127}));
  connect(PEle.y, sumLoa.u[1])
    annotation (Line(points={{59,70},{32,70},{32,69.25}},
                                               color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-96,96},{96,-96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-20,-98},{20,-90}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-18,-100},{18,-90}},
          textColor={0,0,0},
          textStyle={TextStyle.Bold},
          textString="Energy Hub")}),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialGrid;
