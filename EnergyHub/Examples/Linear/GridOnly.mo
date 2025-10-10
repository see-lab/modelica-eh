within EnergyHub.Examples.Linear;
model GridOnly "Linear grid model"
  extends Modelica.Icons.Example;
  extends EnergyHub.Examples.BaseClasses.PartialGrid(
    sumLoa(nin=4, k=-ones(4)));
  extends EnergyHub.Examples.BaseClasses.KeyPerformanceIndicators(
    PGriNet(y=gri.P.real),
    PLoa(y=-sumLoa.y),
    PGen(y=0),
    CCap=0);
  extends EnergyHub.Examples.Data.FluidParameters(
    mDis_flow_nominal=0,
    mLak_flow_nominal=0);
    // Note m*_flow_nominal parameters are not used in this model
  Modelica.Blocks.Math.Gain PHea(k=1/COP_heating)
    "Heating heat pump"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Modelica.Blocks.Math.Gain PDhw(k=1/COP_DHW)
    "DHW heat pump"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Modelica.Blocks.Math.Gain PCoo(k=1/COP_cooling)
    "Cooling heat pump"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Modelica.Blocks.Math.Gain PEle(k=1)
    "Electric power (convert kW to W)"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
equation
  connect(PHea.y, sumLoa.u[2]) annotation (Line(points={{59,30},{52,30},{52,
          69.75},{32,69.75}},
                    color={0,0,127}));
  connect(loaInp.y[2], PHea.u) annotation (Line(points={{99,70},{88,70},{88,30},
          {82,30}},      color={0,0,127}));
  connect(loaInp.y[3], PCoo.u) annotation (Line(points={{99,70},{90,70},{90,-10},
          {82,-10}},       color={0,0,127}));
  connect(loaInp.y[4], PDhw.u) annotation (Line(points={{99,70},{92,70},{92,-50},
          {82,-50}},       color={0,0,127}));
  connect(PCoo.y, sumLoa.u[3]) annotation (Line(points={{59,-10},{50,-10},{50,
          70.25},{32,70.25}},
                        color={0,0,127}));
  connect(PDhw.y, sumLoa.u[4]) annotation (Line(points={{59,-50},{48,-50},{48,
          70.75},{32,70.75}},
                        color={0,0,127}));
  connect(loaInp.y[5], PEle.u) annotation (Line(points={{99,70},{82,70}},color={0,0,127}));
  connect(PEle.y, sumLoa.u[1]) annotation (Line(points={{59,70},{46,70},{46,
          69.25},{32,69.25}},                                             color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{360,120}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Linear/GridOnly.mos"
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
