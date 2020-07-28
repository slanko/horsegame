using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pointToCharInt : MonoBehaviour
{
    // Start is called before the first frame update
    characterInteract charInt;
    void Start()
    {
        charInt = GameObject.Find("Player").GetComponent<characterInteract>();
    }
    void actuallyActuallyThrow()
    {
        charInt.actuallyThrow();
    }
}
