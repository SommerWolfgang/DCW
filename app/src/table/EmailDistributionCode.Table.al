table 12032505 "Email Distribution Code"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland

    Caption = 'Email Distribution Code';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EmailDistributionSetup: Record "Email Distribution Setup";
    begin
        EmailDistributionSetup.Reset;
        EmailDistributionSetup.SetRange("Email Distribution Code", Code);
        EmailDistributionSetup.DeleteAll(true);
    end;

    trigger OnRename()
    var
        EmailDistributionSetup: Record "Email Distribution Setup";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
    end;
}

