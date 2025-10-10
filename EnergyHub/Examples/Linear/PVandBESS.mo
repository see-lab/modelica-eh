within EnergyHub.Examples.Linear;
model PVandBESS "Linear model with grid, PV, and a battery energy storage system (BESS)"
  extends GridWithPV(CCap=capExOnePV*nPV+capExBat*EBatMax);
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(
    etaCha=etaBatChr,
    etaDis=etaBatDis,
    SOC_start=SOC_start,
    EMax=EBatMax,
    V_nominal=V_nominal)
    "Electric battery"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Controls.BatteryControl conBat(
    socMax=socMax,
    socMin=socMin,                             PBatMax=PBatMax,
    PDel=1e-6)                                 "Battery controller"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Invert"
    annotation (Placement(transformation(extent={{0,20},{-20,40}})));
equation
  connect(bat.terminal, loa.terminal) annotation (Line(points={{-60,-20},{-80,
          -20},{-80,70},{-20,70}},color={0,120,120}));
  connect(conBat.PBat, bat.P) annotation (Line(points={{-39,10},{-30,10},{-30,
          -2},{-50,-2},{-50,-10}},
                               color={0,0,127}));
  connect(bat.SOC, conBat.soc) annotation (Line(points={{-39,-14},{-30,-14},{
          -30,-28},{-70,-28},{-70,2},{-62,2}},
                                           color={0,0,127}));
  connect(pv.P, conBat.PGen) annotation (Line(points={{-39,57},{-30,57},{-30,34},
          {-74,34},{-74,10},{-62,10}}, color={0,0,127}));
  connect(sumLoa.y, inv.u)
    annotation (Line(points={{9,70},{6,70},{6,30},{2,30}}, color={0,0,127}));
  connect(inv.y, conBat.PLoa) annotation (Line(points={{-21,30},{-68,30},{-68,18},
          {-62,18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{320,120}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://EnergyHub/Resources/Scripts/Dymola/Examples/Linear/PVandBESS.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVandBESS;
