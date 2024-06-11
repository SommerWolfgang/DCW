table 6086365 "CEM Mileage Detail"
{
    Caption = 'Mileage Details';

    fields
    {
        field(1; "Mileage Entry No."; Integer)
        {
            Caption = 'Mileage Entry No.';
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Detail Entry No."; Integer)
        {
            Caption = 'Detail Entry No.';
        }
        field(5; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            NotBlank = true;
        }
        field(6; "Rate ID"; Code[10])
        {
            Caption = 'Rate ID';
            TableRelation = "CEM Mileage Rate ID";
        }
        field(7; Rate; Decimal)
        {
            Caption = 'Rate';
        }
        field(8; "From Distance"; Decimal)
        {
            Caption = 'From Distance';
            DecimalPlaces = 0 : 2;
        }
        field(9; "To Distance"; Decimal)
        {
            Caption = 'To Distance';
            DecimalPlaces = 0 : 2;
        }
        field(10; Distance; Decimal)
        {
            Caption = 'Distance';
            DecimalPlaces = 0 : 2;
        }
        field(11; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(14; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
            TableRelation = "CEM Vehicle";
        }
        field(23; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(24; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(25; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(60; Reimbursed; Boolean)
        {
            Caption = 'Reimbursed';
            Editable = false;
        }
        field(62; "Reimbursement Method"; Option)
        {
            Caption = 'Reimbursement Method';
            OptionCaption = 'Internal (on User),External Payroll System,Both';
            OptionMembers = "Vendor (on User)","External System",Both;
        }
    }

    keys
    {
        key(Key1; "Mileage Entry No.", "Detail Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Continia User ID", "Registration Date", "Rate ID", Posted, Reimbursed)
        {
            SumIndexFields = Distance, "Amount (LCY)";
        }
        key(Key3; "Continia User ID", Reimbursed, "Registration Date")
        {
            SumIndexFields = Distance, "Amount (LCY)";
        }
        key(Key4; "Continia User ID", "Registration Date", Posted)
        {
            SumIndexFields = Distance, "Amount (LCY)";
        }
        key(Key5; "Continia User ID", "Vehicle Code", "Registration Date", Rate, Posted, Reimbursed)
        {
            SumIndexFields = Distance, "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }


    procedure ShowMileage()
    var
        Mileage: Record "CEM Mileage";
    begin
        if Mileage.Get("Mileage Entry No.") then
            Mileage.OpenDocumentCard();
    end;
}

