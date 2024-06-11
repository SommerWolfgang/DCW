table 6086382 "CEM Per Diem Rate Details"
{
    Caption = 'Per Diem Rate Details';

    fields
    {
        field(1; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            TableRelation = "CEM Per Diem Rate";
        }
        field(2; "Destination Country/Region"; Code[10])
        {
            Caption = 'Destination Country/Region';
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(10; "Minimum Stay (hours)"; Integer)
        {
            Caption = 'Minimum Stay (hours)';

            trigger OnValidate()
            var
                PerDiemRate: Record "CEM Per Diem Rate";
            begin
                if "Minimum Stay (hours)" > 24 then begin
                    PerDiemRate.Get("Per Diem Group Code", "Destination Country/Region", "Start Date");
                    Error(LongerThan24HErr, FieldCaption("Minimum Stay (hours)"), PerDiemRate.TableCaption, PerDiemRate.FieldCaption("Daily Meal Allowance"));
                end;
            end;
        }
        field(11; "Meal Allowance"; Decimal)
        {
            Caption = 'Meal Allowance';
        }
    }

    keys
    {
        key(Key1; "Per Diem Group Code", "Destination Country/Region", "Start Date", "Minimum Stay (hours)")
        {
            Clustered = true;
        }
        key(Key2; "Minimum Stay (hours)")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LongerThan24HErr: Label '%1 cannot be more than 24. %2 - %3 will be used for periods longer than a day.';
}

