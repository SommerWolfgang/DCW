table 6085632 "CDC App. User Group Permission"
{
    Caption = 'Approval User Group Permission';
    DataCaptionFields = "Approval User Group Code";
    PasteIsValid = false;

    fields
    {
        field(2; "Approval User Group Code"; Code[20])
        {
            Caption = 'Approval User Group Code';
            NotBlank = true;
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Item,,Fixed Asset,Charge (Item),Dimension,Job';
            OptionMembers = "G/L Account",Item,,"Fixed Asset","Charge (Item)",Dimension,Job;
        }
        field(4; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
        }
        field(5; "Assigning Permission"; Option)
        {
            Caption = 'Assigning Permission';
            OptionCaption = ' ,All,Include Selected,Exclude Selected,Filter';
            OptionMembers = " ",All,"Include Selected","Exclude Selected","Filter";
        }
        field(6; "Approval Permission"; Option)
        {
            Caption = 'Approval Permission';
            OptionCaption = ' ,All,Include Selected,Exclude Selected,Filter,Same as Assigning';
            OptionMembers = " ",All,"Include Selected","Exclude Selected","Filter","Same as Assigning";

        }
        field(7; "Assigning Filter"; Code[250])
        {
            Caption = 'Assigning Filter';
        }
        field(8; "Approval Filter"; Code[250])
        {
            Caption = 'Approval Filter';
        }
        field(9; "No. of Assigning Selections"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CDC App. User Group Pms. Selec" where("Approval User Group Code" = field("Approval User Group Code"),
                                                                        Type = field(Type),
                                                                        "Dimension Code" = field("Dimension Code"),
                                                                        "Permission Type" = const("Assigning Permission")));
            Caption = 'No. of Assigning Selections';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "No. of Approval Selections"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CDC App. User Group Pms. Selec" where("Approval User Group Code" = field("Approval User Group Code"),
                                                                        Type = field(Type),
                                                                        "Dimension Code" = field("Dimension Code"),
                                                                        "Permission Type" = const("Approval Permission")));
            Caption = 'No. of Approval Selections';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Approval User Group Code", Type, "Dimension Code")
        {
            Clustered = true;
        }
    }
    procedure UpdateContiniaUserPermission()
    begin
    end;

    procedure DrillDownSelection(PermissionType: Option "Assigning Permission","Approval Permission")
    begin
    end;

    procedure LookUpPmsFilter(PermissionType: Option "Assigning Permission","Approval Permission",Both; var Text: Text[250]): Boolean
    begin
        Text := '';
    end;

    procedure LookUpAppUserGrpCode(NewCompanyName: Text[30]; var Text: Text[250]; Editable: Boolean): Boolean
    begin
        Text := '';
    end;

    procedure GetPermissionTxt(PermissionType: Option "Assigning Permission","Approval Permission"; _CompanyName: Text[30]): Text[1024]
    begin
    end;

    procedure GetTypeTxt(): Text[1024]
    begin
    end;
}