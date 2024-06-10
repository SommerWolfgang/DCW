table 6086399 "CEM Assisted Setup"
{
    Caption = 'Assisted Setup';

    fields
    {
        field(1; "Page ID"; Integer)
        {
            Caption = 'Page ID';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; "Order"; Integer)
        {
            Caption = 'Order';
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Not Completed,Completed';
            OptionMembers = "Not Completed",Completed;
        }
    }

    keys
    {
        key(Key1; "Page ID")
        {
            Clustered = true;
        }
        key(Key2; "Order")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RunSetupAgainQst: Label 'You have already completed the %1 assisted setup guide.\\Do you want to run it again?';

    [IntegrationEvent(false, false)]

    procedure OnRegisterAssistedSetup(var AssistedSetupTemp: Record "CEM Assisted Setup" temporary)
    begin
    end;


    procedure RunAssistedSetup()
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if Status = Status::Completed then
            if not Confirm(RunSetupAgainQst, false, Name) then
                exit;

        Commit;
        PAGE.RunModal("Page ID");
        OnUpdateAssistedSetupStatus(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAssistedSetupStatus(var AssistedSetup: Record "CEM Assisted Setup")
    begin
    end;


    procedure AddAssistedSetup(PageID: Integer; PageName: Text[250]; OrderNo: Integer; SetupStatus: Integer)
    var
        AssisteSetup: Record "CEM Assisted Setup";
    begin
        AssisteSetup."Page ID" := PageID;
        AssisteSetup.Name := PageName;
        AssisteSetup.Order := OrderNo;
        AssisteSetup.Status := SetupStatus;
        if not AssisteSetup.Insert then
            AssisteSetup.Modify;
    end;
}

