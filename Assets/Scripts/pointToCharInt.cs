using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pointToCharInt : MonoBehaviour
{
    // Start is called before the first frame update
    characterInteract charInt;
    characterController charCont;
    void Start()
    {
        charInt = GameObject.Find("Player").GetComponent<characterInteract>();
        charCont = GameObject.Find("Player").GetComponent<characterController>();
    }
    void actuallyActuallyThrow()
    {
        charInt.actuallyThrow();
    }

    public void actuallyTeleport()
    {
        charCont.teleportToStable();
    }
}
