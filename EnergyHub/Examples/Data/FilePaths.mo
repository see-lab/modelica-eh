within EnergyHub.Examples.Data;
record FilePaths "Record of paths to externally referenced files"
  parameter String filNam= "modelica://EnergyHub/Resources/Data/January1.mos"
    "Library path of the file with input data as time series";
  parameter String weaFilNam= "modelica://EnergyHub/Resources/weatherdata/FRA_Lyon.074810_IWEC.mos"
    "Library path of the weather file";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end FilePaths;
