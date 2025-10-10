within EnergyHub.Examples.BaseClasses;
model PartialNonlinearSystem "Nonlinear system base class with the electric
  grid, loads, and placeholder blocks for heating, cooling, and domestic hot water
  subsystems."
  extends EnergyHub.Examples.BaseClasses.PartialGrid;
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Heating space heating peak load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    min=Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space cooling load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Heating space heating peak load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.HeatFlowRate QDhw_flow_nominal(
    min=Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Heating space heating peak load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.Power PEle_nominal(
    min=Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Heating space heating peak load (>=0)"
    annotation (Dialog(group="Design parameter"));
  replaceable EnergyHub.Subsystems.BaseClasses.PartialThermalSubsystem hea
    "Space heating"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  replaceable EnergyHub.Subsystems.BaseClasses.PartialThermalSubsystem coo
    "Space cooling"
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  replaceable EnergyHub.Subsystems.BaseClasses.PartialThermalSubsystem dhw
    "DHW"
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  Modelica.Blocks.Math.Gain yHea(k=1/QHea_flow_nominal)
    "Relative heating load"
    annotation (Placement(transformation(extent={{88,16},{78,26}})));
  Modelica.Blocks.Math.Gain yDhw(k=1/QDhw_flow_nominal)
    "Relative DHW load"
    annotation (Placement(transformation(extent={{86,-66},{76,-56}})));
  Modelica.Blocks.Math.Gain yCoo(k=1/QCoo_flow_nominal)
    "Relative load of cooling"
    annotation (Placement(transformation(extent={{84,-26},{74,-16}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaHea(t=1e-4)
    "Threshold comparison to enable heating"
    annotation (Placement(transformation(extent={{80,36},{70,46}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaCoo(t=1e-4)
    "Threshold comparison to enable cooling"
    annotation (Placement(transformation(extent={{80,-4},{70,6}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaDhw(t=1e-4)
    "Threshold comparison to enable DHW"
    annotation (Placement(transformation(extent={{80,-44},{70,-34}})));
equation
  connect(loaInp.y[2],yHea. u) annotation (Line(points={{99,70},{94,70},{94,21},
          {89,21}},      color={0,0,127}));
  connect(loaInp.y[3],yCoo. u) annotation (Line(points={{99,70},{94,70},{94,-21},
          {85,-21}},       color={0,0,127}));
  connect(loaInp.y[4],yDhw. u) annotation (Line(points={{99,70},{94,70},{94,-61},
          {87,-61}},       color={0,0,127}));
  connect(hea.P, sumLoa.u[2]) annotation (Line(points={{38,39},{36,39},{36,
          69.75},{32,69.75}}, color={0,0,127}));
  connect(coo.P, sumLoa.u[3]) annotation (Line(points={{38,-1},{36,-1},{36,
          70.25},{32,70.25}}, color={0,0,127}));
  connect(dhw.P, sumLoa.u[4]) annotation (Line(points={{38,-41},{36,-41},{36,
          70.75},{32,70.75}}, color={0,0,127}));
  connect(enaHea.y, hea.uEna) annotation (Line(points={{69,41},{66,41},{66,39},
          {62,39}}, color={255,0,255}));
  connect(enaCoo.y, coo.uEna) annotation (Line(points={{69,1},{66,1},{66,-1},{
          62,-1}}, color={255,0,255}));
  connect(enaDhw.y, dhw.uEna) annotation (Line(points={{69,-39},{66,-39},{66,-41},
          {62,-41}}, color={255,0,255}));
  connect(yHea.y, hea.yLoa) annotation (Line(points={{77.5,21},{74,21},{74,20},
          {72,20},{72,34},{62,34}}, color={0,0,127}));
  connect(yCoo.y, coo.yLoa) annotation (Line(points={{73.5,-21},{66,-21},{66,-6},
          {62,-6}}, color={0,0,127}));
  connect(yDhw.y, dhw.yLoa) annotation (Line(points={{75.5,-61},{66,-61},{66,-46},
          {62,-46}}, color={0,0,127}));
  connect(yHea.y,enaHea. u) annotation (Line(points={{77.5,21},{72,21},{72,34},{
          88,34},{88,41},{81,41}},  color={0,0,127}));
  connect(yCoo.y,enaCoo. u) annotation (Line(points={{73.5,-21},{66,-21},{66,-6},
          {88,-6},{88,1},{81,1}}, color={0,0,127}));
  connect(yDhw.y,enaDhw. u) annotation (Line(points={{75.5,-61},{66,-61},{66,-46},
          {88,-46},{88,-39},{81,-39}},      color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialNonlinearSystem;
