table 6086368 "CEM Default Dimension"
{
    Caption = 'Default Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
        }
        field(5; "Value Posting"; Option)
        {
            Caption = 'Value Posting';
            OptionCaption = ' ,Code Mandatory,Same Code,No Code';
            OptionMembers = " ","Code Mandatory","Same Code","No Code";
        }
        field(7; "Multi Selection Action"; Option)
        {
            Caption = 'Multi Selection Action';
            OptionCaption = ' ,Change,Delete';
            OptionMembers = " ",Change,Delete;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code")
        {
        }
    }
    procedure GetCaption(): Text[250]
    begin
    end;
}