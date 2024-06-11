table 6085726 "CDC Approval Flow Line"
{
    Caption = 'Approver';

    fields
    {
        field(1; "Approval Flow Code"; Code[10])
        {
            Caption = 'Approval Flow Code';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Approval Flow Code", "Line No.")
        {
            Clustered = true;
        }
    }
}